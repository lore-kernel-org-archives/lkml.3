Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaETAR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 20:17:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39835 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaETAR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 20:17:28 -0400
Message-ID: <537A9EFD.9050208@zytor.com>
Date: Mon, 19 May 2014 17:17:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@kernel.org>,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [GIT PULL] EFI changes for v3.16
References: <20140503130447.GW26088@console-pimps.org> <20140519105129.GF4798@console-pimps.org> <537A8A03.8060604@zytor.com> <20140519231012.GF6311@pd.tnic>
In-Reply-To: <20140519231012.GF6311@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 04:10 PM, Borislav Petkov wrote:
> 
> The question is, why can't that pstore mumbo jumbo go and do its dance
> in !irq context?
> 
> And how useful is the whole deal really, btw? I wanted to use it for
> saving oopses into it, for example, but Tony said its write speed is
> horribly low for that.
> 
> So why do we even bother with this thing and do the dance in irq context
> for it? Is it worth it at all?
> 

I thought the whole point of allowing pstore in IRQ context was to write
oopsen (panics?)

	-hpa

