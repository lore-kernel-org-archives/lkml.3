Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbaGYKFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:05:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37117 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbaGYKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:05:13 -0400
Message-ID: <53D22BCB.9060500@suse.de>
Date: Fri, 25 Jul 2014 12:04:59 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
CC: Michal Simek <michals@xilinx.com>, Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH v2 00/11] ARM: dts: zynq: Prepare Parallella
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <dc23839c-7a69-4674-9d92-80a1d68e9b23@BY2FFO11FD003.protection.gbl>
In-Reply-To: <dc23839c-7a69-4674-9d92-80a1d68e9b23@BY2FFO11FD003.protection.gbl>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Punnaiah,

Am 25.07.2014 05:49, schrieb Punnaiah Choudary Kalluri:
>> Punnaiah Choudary Kalluri had recently proposed to extend the Chipidea
>> USB driver for Zynq; it kept complaining about the PHY though, and I
>> haven't spotted a revised version based on the generic driver yet.
>> https://patchwork.kernel.org/patch/4434681/
> 
> The plan is, go with generic chip idea driver which is currently under review. 
> http://www.spinics.net/lists/linux-usb/msg109576.html
> 
> So, please wait some more time for extending the Chip idea driver support
>  to zynq.

Thanks, I did understand that from the Patchwork link. I was however
wondering whether you already have some work branch based on Antoine
Ténart's series that you could share?

When we get HDMI working, a USB keyboard will come very handy. ;)

Otherwise, could you please take a look at my branch and let me know
whether I'm doing something fundamentally wrong in wiring your old
driver up in my DT? I did not see any .dts example doing so.

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
