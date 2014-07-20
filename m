Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaGTNWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 09:22:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61806 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaGTNWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 09:22:39 -0400
From: Riccardo Lucchese <riccardo.lucchese@gmail.com>
To: gregkh@linuxfoundation.org
Cc: dan.carpenter@oracle.com, oleg.drokin@intel.com, josh@joshtriplett.org,
        dmitry.eremin@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: staging: lustre: lov: Cleanup style issues in lov_request.c
Date: Sun, 20 Jul 2014 15:22:27 +0200
Message-Id: <1405862550-16694-1-git-send-email-riccardo.lucchese@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140720113747.GG18338@mwanda>
References: <20140720113747.GG18338@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series contains one cleanup and two coding style fixes for lov_request.c.

This iteration addresses the review comments received by v1.

Changes in v2:
 - Improved the commit messages.
 - Introduced a local variable in lov_check_set() to make the code clearer.

Thanks,
riccardo
