Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaIHWuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:50:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35945 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbaIHWuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:50:17 -0400
Date: Tue, 9 Sep 2014 07:50:12 +0900
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140908225012.GE3806@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <3827451.ToKxd7Xb2J@vostro.rjw.lan>
 <20140908222253.GB3806@mtj.dyndns.org>
 <2588099.AI1YmNFQ25@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2588099.AI1YmNFQ25@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 09, 2014 at 12:48:28AM +0200, Rafael J. Wysocki wrote:
> Well, not exactly from anywhere.  Just from where try_to_freeze() is called
> I suppose?

Yeap, anywhere try_to_freeze() may be called.

> Which means that if this is a user space task, it won't to a lot before dying,
> will it?

Userland tasks aren't likely to a lot of damages before dying but then
again there's no guarantee.  As it currently stands, try_to_freeze()
can be anywhere.

Thanks.

-- 
tejun
