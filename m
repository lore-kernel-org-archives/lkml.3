Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3A1OZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:25:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1OZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:25:53 -0500
Date: Mon, 28 Jan 2013 09:25:50 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH v2] userns: improve uid/gid map collision detection
Message-ID: <20130128142550.GT17632@redhat.com>
References: <20130123160221.GG17632@redhat.com>
 <20130124044438.GA13354@mail.hallyn.com>
 <20130124152859.GP17632@redhat.com>
 <20130124164612.af6de6f3.akpm@linux-foundation.org>
 <20130125140317.GS17632@redhat.com>
 <871ud8hdyu.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871ud8hdyu.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 06:31:37PM -0800, Eric W. Biederman wrote:
> Aritsteu after looking at both my version and yours I am going with

one extra t.

> mine.  While my code is a little wordier I have half the number of
> comparisons your code does, and I took the time to kill the variable
> introducing a function to test for range collisions makes unnecessary.
> On Andrews size metric my version seems noticably smaller as well.
> 
>  size $PWD-build/kernel/user_namespace.o
>    text	   data	    bss	    dec	    hex	filename
>    4376	    144	      0	   4520	   11a8	/home/eric/projects/linux/linux-userns-devel-build/kernel/user_namespace.o
> 
> 
> Short of something unexpected I plan to push all my code to linux-next
> sometime tomorrow.

sure, no problem
Thanks Eric

-- 
Aristeu

