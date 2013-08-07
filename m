Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3HGPYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:24:25 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:49553 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3HGPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:24:19 -0400
Message-ID: <52026635.1010602@ahsoftware.de>
Date: Wed, 07 Aug 2013 17:22:29 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc25v?= <b-cousson@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Sourav Poddar <sourav.poddar@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Felipe Balbi <balbi@ti.com>,
        Koen Kooi <koen@circuitco.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] arm: omap: Proper cleanups for omap_device
References: <1375775624-12250-1-git-send-email-panto@antoniou-consulting.com> <1375775624-12250-6-git-send-email-panto@antoniou-consulting.com> <20130806093356.GA27889@kroah.com> <8C31ED90-E9EF-4264-858A-17CC2536B552@antoniou-consulting.com> <20130806101421.GA29283@kroah.com> <5200FC09.7080108@ahsoftware.de> <20130807055227.GB5304@kroah.com>
In-Reply-To: <20130807055227.GB5304@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.08.2013 07:52, schrieb Greg Kroah-Hartman:
> On Tue, Aug 06, 2013 at 03:37:13PM +0200, Alexander Holler wrote:
>> Am 06.08.2013 12:14, schrieb Greg Kroah-Hartman:
>>
>>>> What exactly is a platform device anyway?
>>>
>>> Originally it was a "something that wasn't connected to a bus, but just
>>> had memory-mapped i/o."  Like the PS2 keyboard controller.
>>>
>>> Embedded systems got ahold of this and went to town, and made everything
>>> a platform device because they could, and no one was paying attention.
>>>
>>> Then OF came along and used it as well, and you know the rest...
>>>
>>> I think we need to get the ACPI and OF people, and me, in a room
>>> together at the kernel summit and not let us out until we have this all
>>> worked out.
>>
>> MFD uses platform devices too.
>
> Ugh, I've been avoiding looking at mfd for a long time now, and really
> don't want to start now...
>

I've just mentioned it to suggest that platform devices seem to be used 
all over the kernel as the generic (minimal) form of a device driver. At 
least that is the impression I've got.

Regards,

Alexander Holler

