Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab3CXLam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 07:30:42 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:38532 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3CXLal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 07:30:41 -0400
Message-ID: <514EE3DD.6060102@iki.fi>
Date: Sun, 24 Mar 2013 13:30:37 +0200
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Kirk Yap <kirk.s.yap@intel.com>, David Cote <david.m.cote@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/11] Create module providing optimized SHA256 routines
 using SSSE3, AVX or AVX2 instructions.
References: <cover.1363961999.git.tim.c.chen@linux.intel.com> <1363987761.8972.60.camel@schen9-DESK>
In-Reply-To: <1363987761.8972.60.camel@schen9-DESK>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.03.2013 23:29, Tim Chen wrote:
> We added glue code and config options to create crypto
> module that uses SSE/AVX/AVX2 optimized SHA256 x86_64 assembly routines.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---

I could not apply this patch cleanly on top of cryptodev-2.6 tree:

Applying: Create module providing optimized SHA256 routines using SSSE3, AVX or AVX2 instructions.
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging crypto/Kconfig
Auto-merging arch/x86/crypto/Makefile
CONFLICT (content): Merge conflict in arch/x86/crypto/Makefile
Failed to merge in the changes.
Patch failed at 0006 Create module providing optimized SHA256 routines using SSSE3, AVX or AVX2 instructions.

-Jussi
