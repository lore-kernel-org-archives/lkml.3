Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3HVRPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:15:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab3HVRPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:15:33 -0400
Date: Thu, 22 Aug 2013 19:09:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Colin Walters <walters@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] namespaces && fork fixes/cleanups
Message-ID: <20130822170939.GA20296@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The discussion was a bit confusing. I decided to split the changes
to simplify the documentation/review.

Eric, Andy, could you please ack/nack explicitly?

I guess it is too late for 3.11, hopefully Andrew can take these
patches if they pass the review.

OTOH, 1/3 fixes the regression, so perhaps it should cc -stable.

Oleg.

 kernel/fork.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

