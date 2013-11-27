Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab3K0PPC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:15:02 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:34060 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3K0PPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:15:00 -0500
Date: Wed, 27 Nov 2013 10:15:02 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Will Deacon <will.deacon@arm.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] perf: fix PERF_EVENT_IOC_PERIOD to force-reset the
 period
In-Reply-To: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
Message-ID: <alpine.DEB.2.10.1311271013590.4569@vincent-weaver-1.um.maine.edu>
References: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Nov 2013, Will Deacon wrote:

> Vince Weaver reports that, on all architectures apart from ARM,
> PERF_EVENT_IOC_PERIOD doesn't actually update the period until the next
> event fires. This is counter-intuitive behaviour and is better dealt
> with in the core code.

To be fair, it was Andreas Sandberg <andreas.sandberg@it.uu.se>
who noticed this issue and reported it to me (in the context of 
the manpage being wrong).  I just passed it on to the linux-kernel list.

Vince
