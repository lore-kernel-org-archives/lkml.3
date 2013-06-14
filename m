Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3FNQCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:02:44 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50751 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab3FNQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:02:42 -0400
Date: Fri, 14 Jun 2013 09:02:42 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Li Wang <liwang@ubuntukylin.com>
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Kernel file system client support for punch hole
In-Reply-To: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
Message-ID: <alpine.DEB.2.00.1306140858460.26467@cobra.newdream.net>
References: <1371224186-4809-1-git-send-email-liwang@ubuntukylin.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jun 2013, Li Wang wrote:
> This patch implements punch hole (fallocate) support for Ceph kernel
> file system client.
> We prepared two patches based on different kernel versions, one against
> kernel 3.8-rc3, the other against the latest 3.10-rc5. It is because
> unfortunately, we failed to set up a workable Ceph system with the client
> based on the lastest code from Linux kernel git tree, for the server
> side, we tried both the latest code from Ceph git tree and
> the latest v0.61.3 release. The client will easily hang there without
> any response, unless rebooting the machine.

This is odd; was there anything in dmesg?  We test this nightly (currently 
on 3.10-rc5).

> We managed to set up a Ceph system with the client based on Linux 
> kernel 3.8-rc3 and the server based on Ceph v0.61.3, so the patch 
> against v3.8-rc3 has been under preliminary tests. However, the one 
> against v3.10-rc5 not.

Do they differ substantially?  The one against the latest kernel is what 
we'll ultimately apply and merge.

Comments inline...

Thanks!
sage
