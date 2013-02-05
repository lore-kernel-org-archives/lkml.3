Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3BEQ7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:59:18 -0500
Received: from mail-vc0-f169.google.com ([209.85.220.169]:55198 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3BEQ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:59:17 -0500
Date: Tue, 5 Feb 2013 08:59:12 -0800
From: Tejun Heo <htejun@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/3] cleanup memcg controller initialization
Message-ID: <20130205165912.GC4276@mtj.dyndns.org>
References: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360081441-1960-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 05:23:58PM +0100, Michal Hocko wrote:
> Hi,
> this is just a small cleanup I promised some time ago[1]. It just moves
> all memcg controller initialization code independant on mem_cgroup into
> subsystem initialization code.
> 
> There are no functional changes.

Looks good to me.  Thanks for doing this. :)

-- 
tejun
