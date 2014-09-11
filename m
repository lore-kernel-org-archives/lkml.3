Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbaIKPmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:42:20 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60693 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaIKPmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:42:18 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Glauber Costa <glommer@gmail.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>
Subject: [PATCH RFC 0/2] Anonymous memory threshold notifications for memcg
Date: Thu, 11 Sep 2014 19:41:48 +0400
Message-ID: <cover.1410447097.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series introduces anonymous memory threshold notifications for
memory cgroups. For rationale please see the comment to patch 2.

I'm sending it to attract attention to the following thread:

http://www.spinics.net/lists/linux-mm/msg78180.html

Thanks,
Vladimir
