Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaKYWBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 17:01:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49919 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaKYWBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 17:01:17 -0500
Date: Tue, 25 Nov 2014 23:01:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mattias Schlenker <ms@mattiasschlenker.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Cross compile broken - 3.17.3 vs. 3.17.4?
Message-ID: <20141125220112.GA4210@pd.tnic>
References: <5474F177.9030404@mattiasschlenker.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5474F177.9030404@mattiasschlenker.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:15:35PM +0100, Mattias Schlenker wrote:
> Hello everyone,
> 
> when cross compiling with a rather generic x86_64-linux-gnu toolchain I run
> into the problem that "make bzImage" fails. It seems vmlinux binary gets run
> through the hosts objdump and not the $(CROSS_COMPILE)objdump as it was in
> 3.17.3.
> 
> I am not accustomed enough to kernel build habits to immediately spot the
> change that lead to this failed compile (178 files were changed between
> 3.17.3 and 3.17.4). But if you want, I am gonna provide you with a shell
> script that is able to set up the needed toolchain and succeed with 3.17.3
> and fail with 3.17.4. Given my current workload this will take around 48
> hours.

Or you can wait for
http://git.kernel.org/tip/e2e68ae688b0a3766cd75aedf4ed4e39be402009 to hit
3.17-stable.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
