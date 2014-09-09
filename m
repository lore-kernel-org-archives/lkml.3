Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaIIOg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:36:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47501 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaIIOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:36:58 -0400
From: Hugues Morisset <morisset.hugues@gmail.com>
X-Google-Original-From: Hugues Morisset <morisset.hugues@gamil.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugues Morisset <morisset.hugues@gmail.com>
Subject: [PATCH 0/3] fix coding style on lustre
Date: Tue,  9 Sep 2014 16:36:24 +0200
Message-Id: <1410273387-682902-1-git-send-email-morisset.hugues@gamil.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugues Morisset <morisset.hugues@gmail.com>

fix coding style issues including:
* Better alignement of some structures
* Fonction pointer with wrong style
* Remove enums declarations
* A missing empty line

Hugues Morisset (3):
  staging: lustre: fix coding style on long lines     and a missing
    empty line
  staging: lustre: fix inappropriate enums declarations.
  staging: lustre: fix coding style of function's pointer

 drivers/staging/lustre/lustre/include/obd.h   | 52 +++++++++++++--------------
 drivers/staging/lustre/lustre/lmv/lmv_obd.c   |  2 +-
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c |  6 ++--
 3 files changed, 29 insertions(+), 31 deletions(-)

-- 
2.1.0

