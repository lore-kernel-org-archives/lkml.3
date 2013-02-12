Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231Ab3BLOOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 09:14:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56289 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661Ab3BLOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 09:14:52 -0500
Message-ID: <511A4E52.4070909@dawncrow.de>
Date: Tue, 12 Feb 2013 15:14:42 +0100
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] arm: Preserve TPIDRURW on context switch
References: <5112DC7E.4020108@dawncrow.de> <20130206225150.GL17833@n2100.arm.linux.org.uk> <5112E0C3.1080706@dawncrow.de> <20130208154809.GF3495@mudshark.cambridge.arm.com> <511A4B93.1000700@dawncrow.de> <20130212140950.GC4123@mudshark.cambridge.arm.com>
In-Reply-To: <20130212140950.GC4123@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:chIbJytKB5EhKJpgcmbF3xlrsnhBrqV6urQzbxPUFHG
 sY5t5ftPiDlRJMqV73sxgszwCeDoh6izp7Bhx/+5w7ja3GUBOc
 myJJed4uVnNDKqQPCu9+RGtysQH3ZQNYGSSXL8urG4qXtzU8ML
 vh44WLpRw8YNFw60vpXxRrz0gJeIR+vQRPW5gYla97aG6h8qlD
 pj04RUDArZU0jxpsh4hGSmbbe948e5DyS05hpZhfHt6AmecBM9
 FzyHgVqfMiSPljGiAFMaAZ+O3MsHqspuUBN5unuojTl5JOAOi0
 bLNtDthM72vSrqMujtUtMif1Hl7hn3sVUN2nBWHw8Ow8QrXnWl
 ZyilGIxUjVNAfvdjgH+g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.02.2013 15:09, schrieb Will Deacon:
> Hi Andre,
> 
> On Tue, Feb 12, 2013 at 02:02:59PM +0000, André Hentschel wrote:
>> Am 08.02.2013 16:48, schrieb Will Deacon:
>>> On Wed, Feb 06, 2013 at 11:01:23PM +0000, André Hentschel wrote:
>>>> No, i'm not sure how to improve this. How does the process can continue, can you or someone else fix that and add his Signed-off-by?
>>>
>>> How about something like the (completely untested) diff below?
>>>
>>> Andre: if this works for you, I'm happy to write a commit message etc.
>>
>> Thx for your effort, but it doesn't work, at least not with my 3.4.6 suse kernel.
>> Be free to have another try, i'll be happy to test it.
> 
> Well, cheers for testing. Can you be more specific about what goes wrong
> please? What do you see in TPIDRURW?
> 
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Will,

it's 0x00000000 again.

-- 

Best Regards, André Hentschel
