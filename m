Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaCJOH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 10:07:29 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:35997 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaCJOH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 10:07:28 -0400
Date: Mon, 10 Mar 2014 10:07:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] control groups: documentation improvements
Message-ID: <20140310140724.GA25290@htj.dyndns.org>
References: <20140310113928.GC18700@gnimac.gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310113928.GC18700@gnimac.gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glyn.

On Mon, Mar 10, 2014 at 11:39:28AM +0000, Glyn Normington wrote:
> Clarify that each hierarchy must be associated with at least one
> subsystem.

Hmmm... but named hierarchies can exist without any controllers
attached to them.

> Clarify that subsystems may be attached to multiple hierarchies,
> although this isn't very useful, and explain what happens.

And a subsystem may only be attached to a single hierarchy.

Thanks.

-- 
tejun
