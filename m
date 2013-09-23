Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3IWNA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:00:29 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:44255 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3IWNA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:00:27 -0400
Message-ID: <52403B4F.3070406@cogentembedded.com>
Date: Mon, 23 Sep 2013 16:59:59 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: Tejun Heo <tj@kernel.org>, balbi@ti.com, bcousson@baylibre.com,
        tony@atomide.com, balajitk@ti.com, kishon@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH 08/15] ata: ahci_platform: Manage SATA PHY
References: <1379595943-14622-1-git-send-email-rogerq@ti.com> <1379595943-14622-9-git-send-email-rogerq@ti.com> <20130922165817.GD30946@htj.dyndns.org> <523F35E4.6050707@cogentembedded.com> <20130922215107.GD27616@mtj.dyndns.org> <523FEFC2.801@ti.com>
In-Reply-To: <523FEFC2.801@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-09-2013 11:37, Roger Quadros wrote:

>>>     Not sure why you asked -- I'm not using this driver, neither I'm

>> Well, you have better grip of what's going on in the embedded world
>> than me.  I'm mostly curious whether adding dependency on PHY is okay.

> There is no hard dependency on presence of PHY. The driver will continue
> as usual if devm_phy_get() fails.
> I hope selecting GENERIC_PHY in Kconfig is not an issue.

    Selecting in the AHCI_PLATFORM section? It seems I have overlooked it. No, 
I don't think it's a good idea. The generic PHY functions seem to be stubbed 
when GENERIC_PHY=n.

> cheers,
> -roger

WBR, Sergei

