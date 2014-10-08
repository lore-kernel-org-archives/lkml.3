Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbaJHJxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:53:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaJHJxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:53:44 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting (merge window)
Date: Wed,  8 Oct 2014 10:53:09 +0100
Message-Id: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Not a huge amount this time... just four patches. This time we have a couple
of bug fixes, one relating to bad i_goal values which are now ignored (i_goal
is basically a hint so it is safe to so this) and another relating to the
saving of the dirent location during rename. There is one performance
improvement, which is an optimisation in rgblk_free so that multiple block
deallocations will now be more efficient, and one clean up patch to use
_RET_IP_ rather than writing it out longhand,

Steve.


