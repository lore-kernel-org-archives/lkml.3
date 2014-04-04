Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaDDWcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 18:32:23 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:44854 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaDDWcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 18:32:22 -0400
From: Silvio Fricke <silvio.fricke@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Silvio Fricke <silvio.fricke@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [WIP] [PATCH v2 0/3] remove wrong cast of gfp_t flags
Date: Sat,  5 Apr 2014 00:32:07 +0200
Message-Id: <cover.1396627781.git.silvio.fricke@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140403094350.GH6991@mwanda>
References: <20140403094350.GH6991@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

thanks for your review.
Attached second version of this series.

Cheers,
	Silvio


Silvio Fricke (3):
  staging: vt6655: removed incorrect casting in wpactl.c
  staging: vt6655: removed incorrect casting in ioctl.c
  staging: vt6655: removed incorrect casting in iwctl.c

 drivers/staging/vt6655/ioctl.c  | 6 ++++--
 drivers/staging/vt6655/iwctl.c  | 2 +-
 drivers/staging/vt6655/wpactl.c | 6 +++---
 3 files changed, 8 insertions(+), 6 deletions(-)

-- 
1.9.0

