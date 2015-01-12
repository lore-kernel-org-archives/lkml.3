Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbbALWNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:13:13 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57191 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbbALWNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:13:10 -0500
Date: Mon, 12 Jan 2015 17:13:01 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: add BUILD_BUG_ON() for string tables
Message-ID: <20150112221301.GA25609@phnom.home.cmpxchg.org>
References: <1421088863-14270-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421088863-14270-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 10:54:23AM -0800, Greg Thelen wrote:
> Use BUILD_BUG_ON() to compile assert that memcg string tables are in
> sync with corresponding enums.  There aren't currently any issues with
> these tables.  This is just defensive.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>

Looks good to me, thanks Greg.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
