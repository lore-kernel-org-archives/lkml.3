Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3KZQqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:46:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab3KZQqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:46:15 -0500
Date: Tue, 26 Nov 2013 08:46:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, <linux-kernel@vger.kernel.org>,
        <glommer@openvz.org>, <mhocko@suse.cz>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [Devel] [PATCH v11 00/15] kmemcg shrinkers
Message-Id: <20131126084644.405a091d.akpm@linux-foundation.org>
In-Reply-To: <52949A4F.7030004@parallels.com>
References: <cover.1385377616.git.vdavydov@parallels.com>
	<20131125174135.GE22729@cmpxchg.org>
	<529443E4.7080602@parallels.com>
	<52949A4F.7030004@parallels.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 16:55:43 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> What do you think about splitting this set into two main series as follows:
> 
> 1) Prepare vmscan to kmemcg-aware shrinkers; would include patches 1-7 
> of this set.
> 2) Make fs shrinkers memcg-aware; would include patches 9-11 of this set

Please just resend everything.

> and leave other patches, which are rather for optimization/extending 
> functionality, for future?

It will be helpful to describe such splitting opportunities in the
[0/n] changelog.

