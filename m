Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445Ab3BXSKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 13:10:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab3BXSKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 13:10:44 -0500
Date: Sun, 24 Feb 2013 19:09:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] coredump: make it freezable (almost)
Message-ID: <20130224180912.GA1392@redhat.com>
References: <20130224173144.GA32179@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130224173144.GA32179@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24, Oleg Nesterov wrote:
>
> depends on 2/3, lets discuss this series first.

Cough. Not sure how I managed to convince myself that freeze_task()
can't race with zap_threads() and wrongly set TIF_SIGPENDING. I'll
send v2 in reply to 2/3.

Oleg.

