Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab3ERQXu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 12:23:50 -0400
Received: from lan.nucleusys.com ([92.247.61.126]:49101 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378Ab3ERQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 12:23:49 -0400
Date: Sat, 18 May 2013 19:23:32 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: David Miller <davem@davemloft.net>
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] drivers: net: usb: rtl8150: bug fixing and cleanup
Message-ID: <alpine.DEB.2.02.1305181835320.7518@fry.nucleusys.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>

This patch series adds rtl8150.h, which contains structure and constant 
definitons formerly found in rtl8150.c, removes socket buffer 
pre-allocated pool and uses dynamically allocated memory for the 
asynchronous URB requests, thus avoids clobbering the previously scheduled 
for update value.

This patch series is against 'net' tree.

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
