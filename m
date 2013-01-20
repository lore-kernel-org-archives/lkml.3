Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3ATLt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 06:49:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:46270 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab3ATLt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 06:49:56 -0500
Date: Sun, 20 Jan 2013 12:50:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>,
        linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: 3.6.11  AMD-Vi: Completion-Wait loop timed out
Message-ID: <20130120115011.GC16519@pd.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130120114828.GB16519@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 12:48:28PM +0100, Borislav Petkov wrote:
> On Sun, Jan 20, 2013 at 12:40:11PM +0100, Jörg Rödel wrote:
> > Yes, the BIOS vendor can fix this issue. They need to disable NB clock
> > gating for the IOMMU.
> 
> Right, Udo, you can try Gigabyte first.

Btw, you're running the latest BIOS from them, I assume?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
