Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772Ab3DZHNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:13:54 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:37934 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753207Ab3DZHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:13:53 -0400
Date: Fri, 26 Apr 2013 10:13:41 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] drivers: net: usb: pegasus: bug fixing and cleanup
Message-ID: <alpine.DEB.2.02.1304261008410.3772@fry.nucleusys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

This series of patches is fixing a bug related to multiple control URB 
submissions (noted by Sarah Sharp), optimizes read and write_mii_word 
routines and removes socket buffer pool used in the receive path.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
