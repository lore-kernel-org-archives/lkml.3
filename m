Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaAVUCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 15:02:53 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52101 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaAVUCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 15:02:51 -0500
Date: Wed, 22 Jan 2014 21:02:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 65/73] drivers/edac: delete non-required instances of
 include <linux/init.h>
Message-ID: <20140122200249.GC4966@pd.tnic>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-66-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390339396-3479-66-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:23:08PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Doug Thompson <dougthompson@xmission.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Daney <david.daney@cavium.com>
> Cc: linux-edac@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
