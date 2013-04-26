Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656Ab3DZIoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:44:15 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:37946 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932088Ab3DZIoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:44:12 -0400
Date: Fri, 26 Apr 2013 11:44:05 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] drivers: net: usb: pegasus: bug fixing and cleanup
In-Reply-To: <alpine.DEB.2.02.1304261008410.3772@fry.nucleusys.com>
Message-ID: <alpine.DEB.2.02.1304261142070.12284@fry.nucleusys.com>
References: <alpine.DEB.2.02.1304261008410.3772@fry.nucleusys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Petko Manolov wrote:

> From: Petko Manolov <petkan@nucleusys.com>
> 
> This series of patches is fixing a bug related to multiple control URB 
> submissions (noted by Sarah Sharp), optimizes read and write_mii_word 
> routines and removes socket buffer pool used in the receive path.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

I realized that the diffs for this patch series have been made in my git 
repository, not against your latest net-next tree.  Please ignore the 
first set of patches.


