Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbbAOTIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:08:49 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:38460 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbbAOTIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:08:45 -0500
Date: Thu, 15 Jan 2015 14:08:40 -0500
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Konstantin Khebnikov <khlebnikov@yandex-team.ru>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org,
        Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
Message-ID: <20150115190840.GD28195@htj.dyndns.org>
References: <20150115180242.10450.92.stgit@buzz>
 <20150115184914.10450.51964.stgit@buzz>
 <20150115185543.GA28195@htj.dyndns.org>
 <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 15, 2015 at 11:04:49PM +0400, Konstantin Khlebnikov wrote:
> I know. Absolutely accurate per-page solution looks too complicated for me.
> Is there any real demand for accurate handling dirty set in shared inodes?
> Doing whole accounting in per-inode basis makes life so much easier.

Ah, yeah, patch #3 arrived in isolation, so I thought it was part of
something completely different.  I definitely thought about doing it
per-inode too (and also requiring memcg to attribute pages according
to its inode rather than individual pages).  I'll look into the
patchset and try to identify the pros and cons of our approaches.

Thanks.

-- 
tejun
