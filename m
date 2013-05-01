Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab3EACgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 22:36:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:42964 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933396Ab3EACgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 22:36:33 -0400
Date: Wed, 1 May 2013 12:39:45 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: John Johansen <john.johansen@canonical.com>
cc: SECURITY SUBSYSTEM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PULL] apparmor update
In-Reply-To: <517CDB9C.8040001@canonical.com>
Message-ID: <alpine.LRH.2.02.1305011238240.7261@tundra.namei.org>
References: <517CDB9C.8040001@canonical.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Apr 2013, John Johansen wrote:

> Hi James,
> 
> Please pull these apparmor changes for 3.10 (or after is fine as I know
> these are running late for the -security window)

Yep -- patches need to be in -next for at least a week before the merge 
window.  I suggest getting you pull requests to me around the -rc4 mark.


I'll pull these changes after -rc1.



> 
> There are no new features here just a set of small bug fixes and code
> cleanups
> 
> thanks
> -john,
> 
> 
> 
> The following changes since commit b7ae9f064bec903bd4a9f257a35da4d1e9bbcc99:
> 
>   Merge branch 'tpmdd-04-17-13' of git://github.com/shpedoikal/linux into my-next (2013-04-20 09:00:45 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor tags/aa-3.10
> 
> for you to fetch changes up to 2654bfbc2bd0e1e64f0b257c21da23f6cec32c6c:
> 
>   apparmor: fix fully qualified name parsing (2013-04-28 00:39:37 -0700)
> 
> ----------------------------------------------------------------
> apparmor patches for 3.10
> 
> ----------------------------------------------------------------
> John Johansen (20):
>       apparmor: fix auditing of domain transition failures due to incomplete policy
>       apparmor: Remove -W1 warnings
>       apparmor: refactor profile mode macros
>       apparmor: fix error code to failure message mapping for name lookup
>       apparmor: add utility function to get an arbitrary tasks profile.
>       apparmor: add kvzalloc to handle zeroing for kvmalloc
>       apparmor: use common fn to clear task_context for domain transitions
>       apparmor: remove "permipc" command
>       apparmor: relax the restrictions on setting rlimits
>       apparmor: misc cleanup of match
>       apparmor: move perm defines into policy_unpack
>       apparmor: remove sid from profiles
>       apparmor: move the free_profile fn ahead of aa_alloc_profile
>       apparmor: reserve and mask off the top 8 bits of the base field
>       apparmor: fix the audit type table
>       apparmor: Fix smatch warning in aa_remove_profiles
>       apparmor: fix sparse warnings
>       apparmor: localize getting the security context to a few macros
>       apparmor: fix setprocattr arg processing for onexec
>       apparmor: fix fully qualified name parsing
> 
>  security/apparmor/audit.c            |   2 +-
>  security/apparmor/context.c          |  44 +++++----
>  security/apparmor/domain.c           |  26 ++---
>  security/apparmor/include/apparmor.h |  12 ++-
>  security/apparmor/include/context.h  |  61 ++++++++----
>  security/apparmor/include/file.h     |  14 +--
>  security/apparmor/include/match.h    |  21 ++--
>  security/apparmor/include/policy.h   |  16 ++--
>  security/apparmor/include/procattr.h |   1 -
>  security/apparmor/include/sid.h      |   4 +-
>  security/apparmor/ipc.c              |  13 +--
>  security/apparmor/lib.c              |  20 ++--
>  security/apparmor/lsm.c              |  69 +++++++------
>  security/apparmor/match.c            |  23 ++---
>  security/apparmor/path.c             |   2 +-
>  security/apparmor/policy.c           | 181 ++++++++++++++++-------------------
>  security/apparmor/policy_unpack.c    |   4 +-
>  security/apparmor/procattr.c         |   6 --
>  security/apparmor/resource.c         |  15 ++-
>  19 files changed, 286 insertions(+), 248 deletions(-)
> 

-- 
James Morris
<jmorris@namei.org>
