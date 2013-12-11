Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3LKCA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:00:26 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:36877 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab3LKCAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:00:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8IAOfGp1J5LHyk/2dsb2JhbABZgweDOLElhU+BHxd0giUBAQU6HBcMEAgDDgoJJQ8FJQMhE4gBwUsXFo5vB4Q0BJgTkhSDPSg
Date: Wed, 11 Dec 2013 13:00:07 +1100
From: Dave Chinner <david@fromorbit.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Luis Henriques <luis.henriques@canonical.com>,
        Kees Cook <keescook@google.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, Greg KH <gregkh@linuxfoundation.org>,
        xfs@oss.sgi.com, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131211020007.GH10988@dastard>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
 <20131209121534.GE4278@hercules>
 <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
 <20131209235523.GW31386@dastard>
 <CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
 <20131211010326.GF10988@dastard>
 <CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 08:10:51PM -0500, Josh Boyer wrote:
> On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > Security processes are not something that should be hidden away in
> > it's own private corner - if there's a problem upstream needs to
> > take action on, then direct contact with upstream is necessary. We
> > need to know about security issues - even ones that are classified
> > post-commit as security issues - so we are operating with full
> > knowledge of the issues in our code and the impact of our fixes....
> 
> Agreed.  I'm going to interpret your comments at being directed to the
> general audience because otherwise you're just shooting the messenger
> :).

Right, they are not aimed at you - they are aimed at those on the
security side of the fence. I'm tired of learning about CVEs in XFS
code through chinese whispers and/or luck.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
