Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbaFCRr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:47:59 -0400
Received: from ns4.system-techniques.com ([50.0.96.199]:39873 "EHLO
	ns4.baby-dragons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751128AbaFCRr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:47:56 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2014 13:47:56 EDT
Date: Tue, 3 Jun 2014 09:40:57 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [kernel] man-pages-3.68 is released
In-Reply-To: <538784BA.3080807@gmail.com>
Message-ID: <alpine.LNX.2.01.1405291132370.5598@filesrv1.baby-dragons.com>
References: <538784BA.3080807@gmail.com>
User-Agent: Alpine 2.01 (LNX 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ns4.baby-dragons.com [50.0.96.199]); Tue, 03 Jun 2014 10:40:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Helo Michael ,  Thank you !-)  JimL

On Thu, 29 May 2014, Michael Kerrisk (man-pages) wrote:

> Gidday,
>
> The Linux man-pages maintainer proudly announces his 150th release
> as project maintainer:
>
>    man-pages-3.68 - man pages for Linux
>
> Tarball download:
>    http://www.kernel.org/doc/man-pages/download.html
> Git repository:
>    https://git.kernel.org/cgit/docs/man-pages/man-pages.git/
> Online changelog:
>    http://man7.org/linux/man-pages/changelog.html#release_3.68
>
> A short summary of the release is blogged at:
> http://linux-man-pages.blogspot.com/2014/05/man-pages-368-is-released.html
>
> The current version of the pages is browsable at:
> http://man7.org/linux/man-pages/
>
> A few changes in this release that may be of interest to readers of
> this list are given below.
>
> Cheers,
>
> Michael
>
>
> ==================== Changes in man-pages-3.68 ====================
>
> Released: 2014-05-28, Munich
>
>
> New and rewritten pages
> -----------------------
>
> localedef.1
>    Marko Myllynen, Richard Braakman, Alastair McKinstry, Lars Wirzenius
>        New page for localedef(1)
>            Add new page based on Debian localedef(1) page.
>
>
> Changes to individual pages
> ---------------------------
>
> locale.1
>    Marko Myllynen
>        Provide a step-by-step example of how to use a custom locale
>
> fork.2
>    Michael Kerrisk
>        ERRORS: add pid_max and threads-max to EAGAIN
>            And rewrite text to be the same as pthread_create(3).
>
> proc.5
>    Michael Kerrisk
>        'pid_max' is a system-wide limit on number of threads and processes
>            Since PIDs > /proc/sys/kernel/pid_max are not allocated, this
>            file thus also imposes a system-wide limit on the number of
>            threads and processes.
>
> capabilities.7
>    Michael Kerrisk
>        CAP_SYS_ADMIN allows overriding RLIMIT_NPROC
>    Michael Kerrisk
>        CAP_SYS_PTRACE allows process_vm_readv(2) and process_vm_writev(2)
>
> inotify.7
>    Heinrich Schuchardt
>        Add example program
>            This example of the usage of the inotify API shows the
>            usage of inotify_init1(2) and inotify_add_watch(2) as well
>            as polling and reading from the inotify file descriptor.
>
> locale.7
>    Marko Myllynen [Michael Kerrisk]
>        Document the LOCPATH environment variable
>
>

-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 3237     Holden Road |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99709 |   only  on  AXP |
+------------------------------------------------------------------+
