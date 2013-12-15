Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3LORD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 12:03:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52605 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab3LORDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 12:03:25 -0500
Date: Sun, 15 Dec 2013 18:03:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Rashika Kheria <rashika.kheria@gmail.com>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers: edac: Mark the function
 get_mci_for_node_id() as static in sb_edac.c
Message-ID: <20131215170323.GE4282@pd.tnic>
References: <7cddbd4c69ed493f183383e98853181aaf75b26b.1387029387.git.rashika.kheria@gmail.com>
 <0441f508186fc4eeabc8e9c3e4dde013d99405d4.1387029387.git.rashika.kheria@gmail.com>
 <20131214202857.GE17601@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131214202857.GE17601@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 12:28:58PM -0800, Josh Triplett wrote:
> On Sat, Dec 14, 2013 at 07:32:09PM +0530, Rashika Kheria wrote:
> > This patch marks the function get_mci_for_node_id() as static in
> > sb_edac.c because it is not used outside this file.
> > 
> > Thus, it also eliminates the following warning in sb_edac.c:
> > drivers/edac/sb_edac.c:918:22: warning: no previous prototype for ‘get_mci_for_node_id’ [-Wmissing-prototypes]
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
