Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3IYA6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:58:10 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:33915 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019Ab3IYA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:58:06 -0400
Date: Tue, 24 Sep 2013 20:58:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130925005802.GA25777@htj.dyndns.org>
References: <5212DBFA.8030805@asianux.com>
 <20130923150625.GB14547@htj.dyndns.org>
 <52410A40.1000304@asianux.com>
 <20130924040601.GA31575@mtj.dyndns.org>
 <524114B8.3070903@asianux.com>
 <20130924120429.GA2366@htj.dyndns.org>
 <5242331B.4010309@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5242331B.4010309@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Chen.

On Wed, Sep 25, 2013 at 08:49:31AM +0800, Chen Gang wrote:
> > Can you please demonstrate such failure?  You can tell kernel to
> > execute a given binary instead of init with "init=" param.
> 
> OK, I will/should try, today (although I have to spend my additional
> time resource on it. :-( ).

Please note that that's not necessarily "additional" resource that you
spend.  It's more of something necessary to justify the changes you're
suggesting.  It's true that not all bug fixes / improvements require
explicit demonstration but I'm not very convinced about your analysis
partly because I'm not too familiar with the code path but also
because the code has been stable with years and you seem pretty new to
the area.

> Hmm... in fact, in my opinion, interface (especially content system
> call) need make itself consistency, although at present, it can not
> cause issue.

Sure, it should be consistent but I'm not sure what you're perceiving
as inconsistent is actually inconsistent.  Anyways, let's please have
something deomnstratable.  We can think more about the interface
niggles afterwards.

Thanks.

-- 
tejun
