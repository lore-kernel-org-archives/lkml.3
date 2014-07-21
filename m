Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaGUKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:16:17 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:51958 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313AbaGUKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:16:16 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, joe@perches.com
Subject: staging: lustre: lov: Cleanup style issues in lov_request.c
Date: Mon, 21 Jul 2014 12:15:54 +0200
Message-Id: <1405937757-16504-1-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405870223.5135.6.camel@joe-AO725>
References: <1405870223.5135.6.camel@joe-AO725>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series contains one cleanup and two coding style fixes for
lov_request.c.

This iteration addresses the review comments received by v2.

Changes in v3:
 - Renamed the local variable introduced in v2-1/3 to be consistent
   with other definitions in the driver.

Changes in v2:
 - Improved the commit messages.
 - Introduced a local variable in lov_check_set() to make the code
   clearer.

Thanks,
riccardo
