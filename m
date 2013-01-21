Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3AUP3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 10:29:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46420 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab3AUP3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 10:29:23 -0500
Date: Mon, 21 Jan 2013 16:32:20 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121153220.GF4445@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
	Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
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
 <20130121151000.GR25591@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130121151000.GR25591@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 04:10:00PM +0100, Jörg Rödel wrote:
> On Mon, Jan 21, 2013 at 02:09:42PM +0100, Borislav Petkov wrote:
> > [    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
> > [    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
> > [    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
> > [    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)
> 
> Yes, that are BIOS bugs too that prevent interrupt remapping to function
> reliably. But the good thing is that these bugs can be detected easily
> to enable a workaround :-)

Well, I'm all ready to test stuff since this is the latest ASUS BIOS
and I'm not even going to ask them to fix it there based on previous
experience with them :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
