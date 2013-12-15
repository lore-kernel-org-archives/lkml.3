Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3LOQ6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 11:58:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56802 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3LOQ6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 11:58:04 -0500
Date: Sun, 15 Dec 2013 17:58:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: edac: Mark the function
 amd64_decode_bus_error() as static in amd64_edac.c
Message-ID: <20131215165802.GC4282@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <20131214202812.GC17601@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214202812.GC17601@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:28:12PM -0800, Josh Triplett wrote:
> On Sat, Dec 14, 2013 at 07:28:24PM +0530, Rashika Kheria wrote:
> > This patch marks the function amd64_decode_bus_error() as static in
> > amd64_edac.c because it is not used outside this file.
> > 
> > Thus, it also eliminates the following warning in amd64_edac.c:
> > drivers/edac/amd64_edac.c:2038:6: warning: no previous prototype for ‘amd64_decode_bus_error’ [-Wmissing-prototypes]
> > 
> > Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
