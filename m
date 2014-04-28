Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaD1Pzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:55:33 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:45740 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbaD1Pz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140428150034.GC7839@dhcp22.suse.cz>
References: <c232030f96bdc60aef967b0d350208e74dc7f57d.1398605516.git.nasa4836@gmail.com>
 <20140428150034.GC7839@dhcp22.suse.cz>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Mon, 28 Apr 2014 23:54:47 +0800
Message-ID: <CAHz2CGUObc=5g2TspQK-JX0GU9X3HJQ9s4t1ApfNR7qbdH71fw@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] mm/swap.c: split put_compound_page function
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mgorman@suse.de>,
        khalid.aziz@oracle.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:00 PM, Michal Hocko <mhocko@suse.cz> wrote:
> This is a big change and really hard to review to be honest. Maybe a
> split up would make it easier to follow.

Ok,  actually it is quite simple, but the diff looks messy, I will try
to split up
this patch to several phases.

Thanks,
Jianyu Zhan
