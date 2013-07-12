Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3GLFjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:39:42 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52807 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3GLFjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:39:41 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Eric Van Hensbergen <ericvh@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p changes for 3.11 merge window (part	2)
In-Reply-To: <CAFkjPTnWcVCrDYiNAwWMOa=8yLzpdZKUi+v7oSQqt3DinYp4xA@mail.gmail.com>
References: <CAFkjPTnWcVCrDYiNAwWMOa=8yLzpdZKUi+v7oSQqt3DinYp4xA@mail.gmail.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 12 Jul 2013 11:09:31 +0530
Message-ID: <87fvvktjzg.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071205-2674-0000-0000-000009C50EBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Van Hensbergen <ericvh@gmail.com> writes:

> The following changes since commit 2315cb14010c4cb0eb7c1d19fcf90475e4688207:
>
>   9p: Add rest of 9p files to MAINTAINERS entry (2013-05-28 13:47:58 -0500)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.gittags/for-linus-3.11-merge-window-part-2
>
> for you to fetch changes up to f2692ea8d5b535277bc06b315eabd32ef4e7a11c:
>
>   fs/9p: Remove the unused variable "err" in v9fs_vfs_getattr() (2013-07-07
> 22:18:31 -0500)
>
> ----------------------------------------------------------------
> Second round of 9p patches for the 3.11 merge window.
>
> Several of these patches were rebased in order to correct style issues.
> Only stylistic changes were made versus the patches which were in linux-next
> for two weeks.  The rebases have been in linux-next for 3 days and have
> passed my regressions.
>
> The bulk of these are RDMA fixes and improvements.  There's also some
> additions on the extended attributes front to support some additional
> namespaces and a new option for TCP to force allocation of mount requests
> from a priviledged port.
>

Noticed that we have

6390460af8a672754dd6743f326515e98f52b2a7 and 
42fe6484c639e8f79e09f81cb89f4f69db224997

Both are the same fix. 
net/9p: Handle error in zero copy request correctly for 9p2000.u

Any idea what happened ?

-aneesh

