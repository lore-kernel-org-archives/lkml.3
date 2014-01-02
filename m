Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136AbaABM2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:28:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABM2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Thu,  2 Jan 2014 12:28:08 +0000
Message-Id: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a set of small fixes for GFS2. There is a fix to drop
s_umount which is copied in from the core vfs, two patches
relate to a hard to hit "use after free" and memory leak.
Two patches related to using DIO and buffered I/O on the same
file to ensure correct operation in relation to glock state
changes. The final patch adds an RCU read lock to ensure
correct locking on an error path,

Steve.


