Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3AUOw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:52:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53175 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab3AUOwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:52:24 -0500
Date: Mon, 21 Jan 2013 15:55:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121145521.GD4445@pd.tnic>
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
 <20130120115755.GO25591@8bytes.org>
 <20130121130942.GB4445@pd.tnic>
 <50FD4C4B.9080507@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50FD4C4B.9080507@xs4all.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 03:10:19PM +0100, Udo van den Heuvel wrote:
> On 2013-01-21 14:09, Borislav Petkov wrote:
> >> Let's see what happens...
> > 
> > Btw, while we're at it, here's some more h0rkage from my PD box:
> > 
> > [    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> > [    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> > [    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> > [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
> 
> I have:
> 
> # dmesg|grep -i amd-vi
> [    1.125636] AMD-Vi: Found IOMMU at 0000:00:00.2 cap 0x40
> [    1.125701] AMD-Vi:  Extended features:  PreF PPR GT IA
> [    1.131725] AMD-Vi: Lazy IO/TLB flushing enabled
> 
> Is that 'OK'?

That's simply dumping the IOMMU extended features and yes, it is ok.

Mine happen when enabling CONFIG_IRQ_REMAP and they're somewhat related.
Anyways, I decided to show them to Joerg so that he's aware.

Btw, you could try enabling that on your machine and see whether IRQ
remapping works there.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
