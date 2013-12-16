Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab3LPGVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 01:21:17 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:32991 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab3LPGVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 01:21:15 -0500
Message-ID: <52AE9BD7.8070704@schinagl.nl>
Date: Mon, 16 Dec 2013 07:21:11 +0100
From: Oliver Schinagl <oliver@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>, grant.likely@linaro.org,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, dev@linux-sunxi.org,
        maxime.ripard@free-electrons.com, ijc@hellion.org.uk,
        Richard Zhu <r65037@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 2/3] ARM: sunxi: Add an ahci-platform compatible AHCI
 driver for the Allwinner SUNXi series of SoCs
References: <1386159055-10264-1-git-send-email-oliver@schinagl.nl> <1386159055-10264-3-git-send-email-oliver@schinagl.nl> <20131204123708.GD3158@htj.dyndns.org> <529F2677.3070208@schinagl.nl> <20131204131402.GG3158@htj.dyndns.org> <529F2B41.8090009@schinagl.nl> <20131204132312.GH3158@htj.dyndns.org> <20131206100117.59609a8a@skate> <52A19502.1090409@schinagl.nl> <52ADFC44.7040003@redhat.com> <20131215190454.GA32509@htj.dyndns.org>
In-Reply-To: <20131215190454.GA32509@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-12-13 20:04, Tejun Heo wrote:
> Hello, Hans.
>
> On Sun, Dec 15, 2013 at 08:00:20PM +0100, Hans de Goede wrote:
>> I think it would be a good idea to merge ahci upstream using the
>> ahci_imx.c method for now. You already indicated that you were not against
>> doing that for now.
> Well, the thing is nothing actually happened since ahci_imx got
> merged, so I'm wondering maybe there isn't enough pressure.
I a slowly progressing on the improved platform driver, but still 
waiting on an answer about my clock question that I asked a few days ago.
>
>> Oliver is working on getting a cleaner solution for this, but doing this
>> properly takes tinme, and we would like to move forward with getting
>> sunxi ahci support upstream in the mean time.
>>
>> So if it is ok with you we would like to move forward with the version
>> initially posted. Therefor I would like to request you to review it
>> (glossing over the platform device instantiating a platform device
>> approach for now), and provide us with feedback so that we can do a v2
>> and start moving this towards the mainline kernel.
> We still have some time left before the next merge window and if it's
> really necessary, I can submit drivers post -rc1 too, so I'd still
> *much* prefer doing it properly rather than creating more drivers
> which would need to be cleaned up later.
Since I do this in my spare time and my technical skill isn't as 
advanced as some, I don't think I have something reviewed and merge-able 
before that time frame. I do enjoy the challenge and do like working on 
the new ahci_platform framework. and do wish to continue to work on it 
however.

Oliver
>
> Thanks.
>

