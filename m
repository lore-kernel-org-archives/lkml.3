Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3IYBOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:14:18 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:49596 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756676Ab3IYBOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:14:08 -0400
Date: Tue, 24 Sep 2013 21:14:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info' in
 all related extern functions
Message-ID: <20130925011404.GB25777@htj.dyndns.org>
References: <5212DBFA.8030805@asianux.com>
 <20130923150625.GB14547@htj.dyndns.org>
 <52410A40.1000304@asianux.com>
 <20130924040601.GA31575@mtj.dyndns.org>
 <524114B8.3070903@asianux.com>
 <20130924120429.GA2366@htj.dyndns.org>
 <5242331B.4010309@asianux.com>
 <20130925005802.GA25777@htj.dyndns.org>
 <5242372C.4010509@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5242372C.4010509@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 09:06:52AM +0800, Chen Gang wrote:
> OK, I see, the 'root cause' is: "you are not the related maintainer
> either", so it is really necessary for me to spend additional time
> resource on it :-(.

Yeah, at least partly.  That and the fact that I'm not too willing to
dig into the code without further evidence.  It isn't anything strange
to ask tho and I'm likely to do that even for subsystems that I know
intimately if the subject code has been stable / stale for years and
the analysis doesn't seem immediately convincing.  And, if my
experience is anything to go by, it's not too unlikely that you might
hit something which doesn't agree with your current assumptions while
trying to actually trigger the problem.

Thanks.

-- 
tejun
