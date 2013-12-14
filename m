Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab3LNRBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:01:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab3LNRBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:01:15 -0500
Date: Sat, 14 Dec 2013 18:01:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, josh@joshtriplett.org
Subject: Re: [PATCH 1/3] drivers: edac: Mark the function
 amd64_decode_bus_error() as static in amd64_edac.c
Message-ID: <20131214170104.GD29362@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 07:28:24PM +0530, Rashika Kheria wrote:
> This patch marks the function amd64_decode_bus_error() as static in
> amd64_edac.c because it is not used outside this file.
> 
> Thus, it also eliminates the following warning in amd64_edac.c:
> drivers/edac/amd64_edac.c:2038:6: warning: no previous prototype for ‘amd64_decode_bus_error’ [-Wmissing-prototypes]

How do you trigger this? .config and output of

gcc --version

please.

I've never seen this warning before.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
