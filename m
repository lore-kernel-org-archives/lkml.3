Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab3LORAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:00:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56838 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab3LORA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:00:28 -0500
Date: Sun, 15 Dec 2013 18:00:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers: edac: Mark the function
 edac_create_debug_nodes() as static in edac_mc_sysfs.c
Message-ID: <20131215170026.GD4282@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <a1c863b08c0d6f67d03280cf908c771bf26a3239.1387029387.git.rashika.kheria@gmail.com>
 <20131214202833.GD17601@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214202833.GD17601@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:28:33PM -0800, Josh Triplett wrote:
> On Sat, Dec 14, 2013 at 07:30:11PM +0530, Rashika Kheria wrote:
> > This patch marks the function edac_create_debug_nodes() as static in
> > edac_mc_sysfs.c because it is not used outside this file.
> > 
> > Thus, it also eliminates the following warning in edac_mc_sysfs.c:
> > drivers/edac/edac_mc_sysfs.c:917:5: warning: no previous prototype for ‘edac_create_debug_nodes’ [-Wmissing-prototypes]
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
