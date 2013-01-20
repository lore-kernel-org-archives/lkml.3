Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3ATMYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 07:24:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58967 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab3ATMYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 07:24:00 -0500
Date: Sun, 20 Jan 2013 13:24:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130120122421.GD16519@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	=?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
	linux-kernel@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@amd.com>,
	Jacob Shin <jacob.shin@amd.com>
References: <50FBC7EF.6040207@xs4all.nl>
 <20130120103652.GB16800@pd.tnic>
 <50FBC994.8020409@xs4all.nl>
 <20130120111920.GL25591@8bytes.org>
 <50FBD413.1000406@xs4all.nl>
 <20130120114011.GN25591@8bytes.org>
 <20130120114828.GB16519@pd.tnic>
 <20130120115011.GC16519@pd.tnic>
 <50FBDC3F.1090509@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50FBDC3F.1090509@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:59:59PM +0100, Udo van den Heuvel wrote:
> On 2013-01-20 12:50, Borislav Petkov wrote:
> >> Right, Udo, you can try Gigabyte first.
> > 
> > Btw, you're running the latest BIOS from them, I assume?
> 
> Nope. But I am beyond their first released BIOS, I am running one of
> their beta BIOSes. I am two beta updates behind current with F3g.
> They list as description for BIOS F3k:
> 
> 1.    Beta BIOS
> 2.    Modify option of APU and memory voltage
> 3.    Modify option of CPU PWM switch rate
> 4.    Modify memory compatibility
> 5.    Modify ET6 compatibility

Yeah, fixes lists are not always exhaustive, especially with BIOS. You
could try the latest if you can downgrade it easily if something breaks
with F3k.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
