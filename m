Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3HWLDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303Ab3HWLDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:03:19 -0400
Date: Fri, 23 Aug 2013 13:03:10 +0200
From: Karel Zak <kzak@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, shli@kernel.org,
        jmoyer@redhat.com, kosaki.motohiro@gmail.com, riel@redhat.com,
        lwoodman@redhat.com, mgorman@suse.de
Subject: Re: [PATCH 02/02] swapon: allow a more flexible swap discard policy
Message-ID: <20130823110310.GA2352@x2.net.home>
References: <cover.1369529143.git.aquini@redhat.com>
 <6346c223ca2acb30b35480b9d51638466aac5fe6.1369530033.git.aquini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6346c223ca2acb30b35480b9d51638466aac5fe6.1369530033.git.aquini@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 01:31:56AM -0300, Rafael Aquini wrote:
>  sys-utils/swapon.8 | 24 +++++++++++++------
>  sys-utils/swapon.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 77 insertions(+), 17 deletions(-)

 Applied, thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
