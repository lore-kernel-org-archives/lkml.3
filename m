Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab3DUWsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 18:48:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41877 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3DUWsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 18:48:50 -0400
Date: Mon, 22 Apr 2013 00:48:59 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
Message-ID: <20130421224859.GC4593@pd.tnic>
References: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
 <51741CB2.3090209@zytor.com>
 <20130421174456.GA4559@pd.tnic>
 <517469BD.3060406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <517469BD.3060406@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 03:35:41PM -0700, H. Peter Anvin wrote:
> Looks like it is just trying to sense the bug... but then it doesn't
> actually do anything about it. At least it should taint the kernel.

Yeah, I was thinking of asking my old contacts about it but it is simply
not worth it. Those CPUs are on their way to the museum if they're not
there already.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
