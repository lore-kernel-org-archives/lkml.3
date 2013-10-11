Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3JKM2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:28:34 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:43614 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3JKM2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:28:33 -0400
From: Matias Bjorling <m@bjorling.me>
To: tj@kernel.org, koverstreet@google.com, paulmck@linux.vnet.ibm.com,
        tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH] Export percpu-refcount functions
Date: Fri, 11 Oct 2013 14:28:11 +0200
Message-Id: <1381494492-1735-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "percpu_ref_kill_and_confirm" [...] undefined!

Working on a driver that needs them, but other modules might benefit as well.

Matias Bjorling (1):
  percpu-refcount: Export symbols

 lib/percpu-refcount.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.1.2

