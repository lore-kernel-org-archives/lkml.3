Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3GTNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 09:25:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37087 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3GTNZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 09:25:56 -0400
Date: Sat, 20 Jul 2013 15:25:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: George Spelvin <linux@horizon.com>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] x86 fixes for 3.11-rc2
Message-ID: <20130720132548.GA13759@pd.tnic>
References: <20130720122504.25856.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130720122504.25856.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 20, 2013 at 08:25:04AM -0400, George Spelvin wrote:
> It's marginal with only two call sites, but would it be worth factoring
> out the write-back function?  Something like this (untested) patch.
> It definitely makes the generated assembly cleaner.

I don't think that matters because this is called only once on suspend.
Unless the cleaner assembly translates into a palpable speedup, which I
doubt.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
