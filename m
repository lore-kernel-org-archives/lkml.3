Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaEGGWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:22:21 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49921 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaEGGWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:22:20 -0400
From: Toby Smith <toby@tismith.id.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Toby Smith <toby@tismith.id.au>
Subject: [PATCH 0/2] staging: lustre: fix sparse warnings in lib-eq.c
Date: Wed,  7 May 2014 16:21:20 +1000
Message-Id: <cover.1399443599.git.toby@tismith.id.au>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warnings from sparse in lib-eq.c

Toby Smith (2):
  staging: lustre: fix sparse warning "should it be static"
  staging: lustre: fix sparse warning "unexpected unlock"

 drivers/staging/lustre/lnet/lnet/lib-eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.9.1

