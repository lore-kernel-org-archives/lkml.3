Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaFKUju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:39:50 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:56045 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaFKUjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:47 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] rcu: fix sparse warnings
Date: Wed, 11 Jun 2014 16:39:38 -0400
Message-Id: <1402519183-12752-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series fixes sparse warning. There are still 3 warnings left
which I am figuring out. I wanted to send these to get feedback and see if I am
on the right path.

Patch 1 is the significant one which involves some refactoring. I am guessing
the 3 remaining sparse warnings will require similar refactoring.

Patch 4 remove the __noreturn attribute as this confuses sparse. I am not sure
if removing this is the right thing to do or if we should be fixing sparse.

The other 3 are trivial.

Pranith Kumar (5):
  kernel/rcu/tree.c:1272 fix a sparse warning 
  kernel/rcu/tree_plugin.h:1494 fix a sparse warning 
  kernel/rcu/tree_plugin.h:990 fix a sparse warning
  kernel/rcu/tree.c:3435 fix a sparse warning
  kernel/rcu/rcutorture.c:185 fix a sparse warning 

 kernel/rcu/rcutorture.c  |  2 +-
 kernel/rcu/tree.c        | 70 +++++++++++++++++++++++++++---------------------
 kernel/rcu/tree_plugin.h |  3 +++
 3 files changed, 43 insertions(+), 32 deletions(-)

-- 
1.9.1

