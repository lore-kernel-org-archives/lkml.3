Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab3B1OYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:24:48 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:54510 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab3B1OYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:24:47 -0500
Date: Thu, 28 Feb 2013 18:24:40 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: For review: pid_namespaces(7) man page
Message-ID: <20130228142440.GA6328@cachalot>
References: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAki=mUYuu_Ewhe7sjCmo+Dq2Vr+FZCixqNRaadcvAxtpFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, Feb 28, 2013 at 12:24 +0100, Michael Kerrisk (man-pages) wrote:
>    The namespace init process
>        The first process created in a new namespace (i.e., the process
>        created using clone(2) with the CLONE_NEWPID flag, or the first
>        child created by a process after a call to unshare(2) using the
>        CLONE_NEWPID flag) has the PID 1, and is the "init" process for
>        the namespace (see init(1)).  Children that are orphaned within
>        the namespace will be reparented to this  process  rather  than
>        init(1).

Probably it worth noting here that this is true unless
prctl() with PR_SET_CHILD_SUBREAPER option is called.

Thanks,

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
