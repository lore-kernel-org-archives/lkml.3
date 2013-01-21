Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3AUNGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:06:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab3AUNGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:06:44 -0500
Date: Mon, 21 Jan 2013 14:09:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130121130942.GB4445@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130120115755.GO25591@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:57:55PM +0100, Jörg Rödel wrote:
> BorisO is no longer with AMD afaik.

Why am I not surprised...

> I wrote an email to Sherry and Suravee and asked them to either send
> me hardware to write the fix on my own or to send a fix for the issue.
> Let's see what happens...

Btw, while we're at it, here's some more h0rkage from my PD box:

[    0.220022] [Firmware Bug]: AMD-Vi: IOAPIC[9] not in IVRS table
[    0.220078] [Firmware Bug]: AMD-Vi: IOAPIC[10] not in IVRS table
[    0.220132] [Firmware Bug]: AMD-Vi: No southbridge IOAPIC found in IVRS table
[    0.220187] AMD-Vi: Disabling interrupt remapping due to BIOS Bug(s)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
