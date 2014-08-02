Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaHBDzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 23:55:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46961 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaHBDzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 23:55:41 -0400
From: Richard Yao <ryao@gentoo.org>
To: kernel@gentoo.org
Cc: Mateusz Guzik <mguzik@redhat.com>, mthode@mthode.org, michael@fds-team.de,
        drobbins@funtoo.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/1] vfs: Respect MS_RDONLY at bind mount creation
Date: Fri,  1 Aug 2014 23:55:11 -0400
Message-Id: <1406951712-17687-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140801192017.GC1850@mguzik.redhat.com>
References: <20140801192017.GC1850@mguzik.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This revision introduces CL_MAKE_RDONLY to propagate the request to make things
readonly all the way to clone_mnt() as suggested by Mateusz Guzik.

Richard Yao (1):
  vfs: Respect MS_RDONLY at bind mount creation

 fs/namespace.c | 15 +++++++++++----
 fs/pnode.h     | 17 +++++++++--------
 2 files changed, 20 insertions(+), 12 deletions(-)

-- 
1.8.5.5

