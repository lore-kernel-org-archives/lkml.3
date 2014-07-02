Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaGBTnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:43:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49091 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbaGBTny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:43:54 -0400
Date: Wed, 2 Jul 2014 21:43:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: add MPX to disaabled features
Message-ID: <20140702194346.GM1318@pd.tnic>
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
 <20140702162930.6209A1AA@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140702162930.6209A1AA@viggo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 09:29:30AM -0700, Dave Hansen wrote:
> 
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This will go in to the MPX patch set, but I'm posting it here so
> folk can see how it will work since it was the original
> motivation for this work.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
