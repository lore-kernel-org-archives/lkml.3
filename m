Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaGEUbC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:31:02 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42719 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbaGEUbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:31:00 -0400
From: Pawel Lebioda <pawel.lebioda89@gmail.com>
To: Julian Andres Klode <jak@jak-linux.org>, Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, ac100@lists.launchpad.net,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] staging: nvec: fix some coding style problems
Date: Sat,  5 Jul 2014 22:30:54 +0200
Message-Id: <cover.1404586529.git.pawel.lebioda89@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix some warnings reported by checkpatch.pl

Pawel Lebioda (2):
  staging: nvec: remove unnecessary 'else' after 'return' statement
  staging: nvec: remove unneccessary 'out of memory' message

 drivers/staging/nvec/nvec.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
1.8.3.2

