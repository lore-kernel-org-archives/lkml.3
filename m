Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbaERRTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 13:19:23 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42557 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbaERRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 13:19:20 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com,
        oleg.drokin@intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 0/5] staging: lustre: lnet: klnds: Fix coding style in socklnd.c
Date: Sun, 18 May 2014 18:19:12 +0100
Message-Id: <1400433557-24985-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix warnings below in socklnd.c to meet coding style.
Also fix some indenting due to changes to keep readability.

WARNING: space prohibited between function name and open parenthesis '('
WARNING: line over 80 characters

Masaru Nomura (5):
  staging: lustre: lnet: socklnd: Remove prohibited space
  staging: lustre: lnet: socklnd: Clean up memset(...)
  staging: lustre: lnet: socklnd: Clean up CDEBUG(...)
  staging: lustre: lnet: socklnd: Clean up ksocknal_get_peer_info(...)
  staging: lustre: lnet: socklnd: Clean up ksocknal_create_conn(...)

 .../staging/lustre/lnet/klnds/socklnd/socklnd.c    |  242 ++++++++++----------
 1 file changed, 121 insertions(+), 121 deletions(-)

-- 
1.7.9.5

