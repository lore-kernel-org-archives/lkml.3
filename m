Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab3JNJ2d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:28:33 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45344 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839Ab3JNJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:28:31 -0400
From: Matias Bjorling <m@bjorling.me>
To: tj@kernel.org, kmo@daterainc.com, paulmck@linux.vnet.ibm.com,
        tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, Matias Bjorling <m@bjorling.me>
Subject: [PATCH v2] Export percpu-refcount functions
Date: Mon, 14 Oct 2013 10:55:31 +0200
Message-Id: <1381740932-14419-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "percpu_ref_kill_and_confirm" [...] undefined!

Working on a driver that needs them, but other modules might benefit as well.

The second version changes export symbols to GPL per Paul and Tejun's
suggestion.

(https://lkml.org/lkml/2013/10/11/370)

Kent, will you replace the previous patch with the updated. Sorry for the
inconvenience.

Changes in v2:
[1/1] Uses EXPORT_SYMBOL_GPL

Matias Bjorling (1):
  percpu-refcount: Export symbols

 lib/percpu-refcount.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
1.8.1.2

