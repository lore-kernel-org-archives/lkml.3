Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750875AbaLORvo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 12:51:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55449 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbaLORvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 12:51:41 -0500
Date: Mon, 15 Dec 2014 18:51:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arne Goedeke <el@laramies.com>, Michal Schmidt <mschmidt@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] exit: fix race between wait_consider_task() and
	wait_task_zombie()
Message-ID: <20141215175111.GA22413@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I think this is v3.19/stable material. Just in case, this bug is old,
it wasn't introduced by the recent changes.

Oleg.

