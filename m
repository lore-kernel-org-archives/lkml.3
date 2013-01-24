Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab3AXTuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:50:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391Ab3AXTuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:50:01 -0500
Message-Id: <20130124194957.198022148@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Thu, 24 Jan 2013 14:49:57 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v2 0/4] devcg: introduce proper hierarchy support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements device cgroup hierarchy. Behaviors and exceptions
will be propagated down in the tree and local preferences will be re-evaluated
everytime a change in its parent occours, reapplying them if it's still
possible.

v2:
- rebase on top "device_cgroup: don't grab mutex in rcu callback"
- in case parent changes behavior or exceptions and the local exceptions won't
  apply anymore, remove them instead of keeping them around.

Cc: Tejun Heo <tj@kernel.org>                                                                                               
Cc: Serge Hallyn <serge.hallyn@canonical.com>                                                                               
Signed-off-by: Aristeu Rozanski <aris@redhat.com>                                                                           

-- 
Aristeu
