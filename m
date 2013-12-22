Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab3LVTvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:51:43 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:42635 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab3LVTvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:51:42 -0500
Date: Sun, 22 Dec 2013 11:49:33 -0800
From: Olof Johansson <olof@lixom.net>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [PATCH v4 2/2] ARM: mach-moxart: add MOXA ART SoC device tree
 files
Message-ID: <20131222194933.GE9144@quad.lixom.net>
References: <1386945188-8316-1-git-send-email-jonas.jensen@gmail.com>
 <1386945188-8316-3-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386945188-8316-3-git-send-email-jonas.jensen@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Fri, Dec 13, 2013 at 03:33:08PM +0100, Jonas Jensen wrote:
> Add a generic (dtsi) include file for MOXA ART SoCs.
> 
> Also add a file for UC-7112-LX.
> 
> Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>

Applied to next/dt. Again, please follow up with some of the comments -- in
particular the requests to keep the SoC IP blocks in the dtsi file and only
enable/disable or amend the entries in the per-board file depending on actual
board configuration. But I didn't see a reason to not merge it while that's
being cleaned up, etc.


-Olof
