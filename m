Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbaGRKiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761154AbaGRKiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (fixes)
Date: Fri, 18 Jul 2014 11:37:37 +0100
Message-Id: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are the current set of small fixes relating to GFS2.

This patch set contains two minor docs/spelling fixes, some fixes for
flock, a change to use GFP_NOFS to avoid recursion on a rarely used code
path and a fix for a race relating to the glock lru,

Steve.

