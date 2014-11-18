Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835AbaKRV34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:29:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbaKRV3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:29:55 -0500
Date: Tue, 18 Nov 2014 22:29:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] exit: find_new_reaper() fixes/cleanups
Message-ID: <20141118212952.GA4754@redhat.com>
References: <20141107201424.GA22209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107201424.GA22209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14, Oleg Nesterov wrote:
>
> Yes, exit_notify() needs more changes but I was distracted, will
> do later.

but I found other bugs in this area. Fix them first. This is also
preparation for the next changes in exit_notify() paths.

Oleg.

 kernel/exit.c |   98 +++++++++++++++++++++++++++++++++-----------------------
 1 files changed, 58 insertions(+), 40 deletions(-)

