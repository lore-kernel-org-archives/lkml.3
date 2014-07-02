Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbaGBTeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:34:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49479 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754452AbaGBTeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:34:24 -0400
Date: Wed, 2 Jul 2014 21:34:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: add more disabled features
Message-ID: <20140702193416.GL1318@pd.tnic>
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
 <20140702162929.8EEB0019@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702162929.8EEB0019@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:29:29AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> There are a few other features than MPX that we can make
> assumptions about at compile-time based on compile options.
> Add them to disabled-features.h and check them with
> cpu_feature_enabled().
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
