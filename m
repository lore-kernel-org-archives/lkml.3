Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaG1Fba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 01:31:30 -0400
Received: from mail-yk0-f169.google.com ([209.85.160.169]:52497 "EHLO
	mail-yk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaG1Fb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 01:31:28 -0400
From: Jessica Yu <jyu@cowsay.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Jessica Yu <jyu@cowsay.org>
Subject: [PATCH v2 0/4] Staging: lustre: linux-module: fix style issues
Date: Mon, 28 Jul 2014 06:33:11 -0700
Message-Id: <1406554395-22779-1-git-send-email-jyu@cowsay.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
References: <1406521542-25363-1-git-send-email-jyu@cowsay.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I revisited my original patch and realized that it should be split into
separate parts.

Jessica Yu (4):
  Staging: lustre: linux-module: fix pointer style issue
  Staging: lustre: linux-module: remove unnecessary spaces
  Staging: lustre: linux-module: remove extraneous parens
  Staging: lustre: linux-module: add const modifier to file_operations

 drivers/staging/lustre/lustre/libcfs/linux/linux-module.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
2.0.1

