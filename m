Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab3LKCKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:10:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3LKCKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:10:44 -0500
Date: Tue, 10 Dec 2013 18:12:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kees Cook <keescook@google.com>,
        Dwight Engen <dwight.engen@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: XFS security fix never sent to -stable?
Message-ID: <20131211021213.GA18168@kroah.com>
References: <CAGXu5jLKkgYg5UWJc8xBGN5NgDh68Q3YRxO--zmDL86BWPH78A@mail.gmail.com>
 <20131209121534.GE4278@hercules>
 <CA+5PVA4ychvLEi1ZZ6rYy2=5-wZAbQ_a-aoy8=1w3+tr-pt3Fg@mail.gmail.com>
 <20131209235523.GW31386@dastard>
 <CA+5PVA5rUmWYQiPwkN15CnfqckmEjVukXz3mU75CiUBVzfERqA@mail.gmail.com>
 <20131211010326.GF10988@dastard>
 <CA+5PVA7wso5fo11xX9kCUdbrqBQMzUnYwTOB_Qe3K7LDY4z_Cw@mail.gmail.com>
 <20131211020007.GH10988@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211020007.GH10988@dastard>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:00:07PM +1100, Dave Chinner wrote:
> On Tue, Dec 10, 2013 at 08:10:51PM -0500, Josh Boyer wrote:
> > On Tue, Dec 10, 2013 at 8:03 PM, Dave Chinner <david@fromorbit.com> wrote:
> > > Security processes are not something that should be hidden away in
> > > it's own private corner - if there's a problem upstream needs to
> > > take action on, then direct contact with upstream is necessary. We
> > > need to know about security issues - even ones that are classified
> > > post-commit as security issues - so we are operating with full
> > > knowledge of the issues in our code and the impact of our fixes....
> > 
> > Agreed.  I'm going to interpret your comments at being directed to the
> > general audience because otherwise you're just shooting the messenger
> > :).
> 
> Right, they are not aimed at you - they are aimed at those on the
> security side of the fence. I'm tired of learning about CVEs in XFS
> code through chinese whispers and/or luck.

CVEs for the kernel are almost always "assigned" after the problem is
fixed, or when people "notice" something was changed upstream.  At that
point, there's no need for the original committer to be notified, as
there's nothing to do.

Anyway, I understand your frustration about CVEs, I don't like them much
either, but some people do, so let them deal with them, and don't give
them a second thought.

greg k-h
