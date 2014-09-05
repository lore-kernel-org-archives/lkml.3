Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbaIEOJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:09:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:39667 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIEOJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:09:14 -0400
Date: Fri, 5 Sep 2014 23:09:02 +0900
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [Patch v4 2/2] freezer: remove obsolete comments in __thaw_task()
Message-ID: <20140905140902.GB10455@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1409869842-10807-2-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409869842-10807-2-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 03:30:42PM -0700, Cong Wang wrote:
> __thaw_task() no longer clears frozen flag since commit a3201227f803
> (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE).
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
