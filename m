Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab3CKXbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:31:43 -0400
Received: from cobra.newdream.net ([66.33.216.30]:40722 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3CKXbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:31:41 -0400
Date: Mon, 11 Mar 2013 16:31:41 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for -rc3
Message-ID: <alpine.DEB.2.00.1303111630130.26131@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fix from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This fixes a bug in the new message decoding that just went in during the 
last window.

Thanks!
sage


----------------------------------------------------------------
Sage Weil (1):
      libceph: fix decoding of pgids

 net/ceph/osdmap.c |   42 +++++++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 13 deletions(-)
