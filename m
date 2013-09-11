Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab3IKRUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab3IKRUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:20:20 -0400
Date: Wed, 11 Sep 2013 19:13:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] proc: make proc_fd_permission() thread-friendly
Message-ID: <20130911171341.GA15371@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, could you take this patch?

It was lost in the lost discussion. Linus agrees with this change,
and afaics Eric doesn't object.

v2:
	update the changelog

Oleg.

