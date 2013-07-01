Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3GAJ7r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3GAJ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Mon,  1 Jul 2013 10:33:03 +0100
Message-Id: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a few bug fixes for various, mostly very minor corner
cases, plus some interesting new features. The new features
include atomic_open whose main benefit will be the reduction in
locking overhead in case of combined lookup/create and open operations,
sorting the log buffer lists by block number to improve the efficiency
of AIL writeback, and agressively issuing revokes in gfs2_log_flush
to reduce overhead when dropping glocks,

Steve.


