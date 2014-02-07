Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaBGREb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:04:31 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58546 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaBGREa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:04:30 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] memcg: charge path cleanups
Date: Fri,  7 Feb 2014 12:04:17 -0500
Message-Id: <1391792665-21678-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

I took some of your patches and combined them with the charge path
cleanups I already had and the changes I made after our discussion.

I'm really happy about where this is going:

 mm/memcontrol.c | 298 ++++++++++++++++--------------------------------------
 1 file changed, 87 insertions(+), 211 deletions(-)

let me know what you think!

Johannes

