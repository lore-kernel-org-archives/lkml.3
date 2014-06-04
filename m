Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaFDWtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:49:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbaFDWts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:49:48 -0400
Date: Thu, 5 Jun 2014 00:49:20 +0200
From: Borislav Petkov <bp@suse.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        ricardo.neri-calderon@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/efi] x86/efi: Check for unsafe dealing with FPU state
 in irq ctxt
Message-ID: <20140604224920.GB4126@pd.tnic>
References: <tip-baa916f39b50ad91661534652110df40396acda0@git.kernel.org>
 <538F9AFA.5050806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <538F9AFA.5050806@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 03:17:30PM -0700, H. Peter Anvin wrote:
> I seem to have lost track of this... does this actually solve
> anything, or does it just mean we'll explode hard?

Not that hard - it'll warn once only.

AFAIR, the discussion stalled but we were going in the direction of not
calling into efi from pstore in irq context.

I'd say we drop this until we have a proper solution.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
