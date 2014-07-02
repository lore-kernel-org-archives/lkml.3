Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaGBTTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:19:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48717 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaGBTTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:19:21 -0400
Date: Wed, 2 Jul 2014 21:19:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: axe the lightly-used cpu_has_pae
Message-ID: <20140702191912.GJ1318@pd.tnic>
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
 <20140702162926.3F2DAC08@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702162926.3F2DAC08@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:29:26AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> cpu_has_pae is only referenced in one place: the X86_32 kexec
> code (in a file not even built on 64-bit).  It hardly warrants
> its own macro, or the trouble we go to ensuring that it can't
> be called in X86_64 code.
> 
> Axe the macro and replace it with a direct cpu feature check.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
