Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3FIMlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 08:41:05 -0400
Received: from mout.gmx.net ([212.227.17.20]:57178 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab3FIMlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 08:41:02 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+MWqsEIDOM+gaXlVtgiltFD00rT/JxytNumf8j6y
	8kxirhLuK0KbBr
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: filesystem notification fixes/cleanup
Date: Sun,  9 Jun 2013 14:40:41 +0200
Message-Id: <1370781646-10496-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 1.7.9.5
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series fixes a couple of races (fanotify/inotify) or simplifies code
(dnotify) by means of the fsnotify groups mark mutex. The last patch updates the
comments in fs/notify/mark.c concerning the changed fsnotify locking implementation.

Regards,
Lino

[PATCH 1/5] fanotify: Fix races when adding/removing marks
[PATCH 2/5] fanotify: Put duplicate code for adding vfsmount/inode
[PATCH 3/5] dnotify: replace dnotify_mark_mutex with mark mutex of
[PATCH 4/5] inotify: fix race when adding a new watch
[PATCH 5/5] fsnotify: update comments concerning locking scheme
