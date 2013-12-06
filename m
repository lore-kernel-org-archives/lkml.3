Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758547Ab3LFNiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:38:17 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:59657 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab3LFNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:38:14 -0500
Date: Fri, 6 Dec 2013 14:38:27 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>
Subject: Re: [PATCH 1/3] arm64: add EFI stub
Message-ID: <20131206133827.GB24997@rocoto.smurfnet.nu>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
 <1385762712-17043-2-git-send-email-msalter@redhat.com>
 <20131205141853.GA974@darko.cambridge.arm.com>
 <1386254603.1861.120.camel@deneb.redhat.com>
 <20131205152806.GC974@darko.cambridge.arm.com>
 <20131206122511.301D6C40757@trevor.secretlab.ca>
 <1386336870.1861.155.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386336870.1861.155.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 08:34:30AM -0500, Mark Salter wrote:
> > Or just disable runtime services on the switch to big ending. Big endian
> > should not disable the stub (but getting it to work could be a follow-up
> > patch)
> > 
> The other problem with BE is that the PE/COFF masquerading is built into
> head.S so the same Image can be used for EFI and non-EFI. I don't see
> a BE opcode which we could us to provide the magic "MZ" at the start
> of a BE kernel Image.

That's actually not an issue.
Instructions are always LE - endinaness affects only data.

/
    Leif
