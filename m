Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161788Ab3DEKX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3DEKXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:23:54 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Fri,  5 Apr 2013 10:57:10 +0100
Message-Id: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are a few GFS2 fixes which are pending. There are two patches
which fix up a couple of minor issues in the DLM interface code,
a missing error path in gfs2_rs_alloc(), two patches which fix problems
during "withdraw" and a fix for discards/FITRIM when using 4k sector
sized devices,

Steve.


