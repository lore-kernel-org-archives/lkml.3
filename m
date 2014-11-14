Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbaKNBhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:37:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934020AbaKNBhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:37:43 -0500
Date: Fri, 14 Nov 2014 02:37:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Rik van Riel <riel@redhat.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] exit: more cleanups/optimizations
Message-ID: <20141114013750.GA4697@redhat.com>
References: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Oleg Nesterov wrote:
>
> Plus cleanups + initial (micro)optimizations, more to come.

Yes, exit_notify() needs more changes but I was distracted, will
do later.

Until then some more "exit:" changes which also makes sense imo.

Oleg.


 fs/proc/base.c |    3 ++
 kernel/exit.c  |   58 ++++++++++++++++++++++++-------------------------------
 2 files changed, 28 insertions(+), 33 deletions(-)

