Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaG3VCi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 17:02:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:44431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaG3VCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 17:02:37 -0400
Message-ID: <53D95D68.1000402@infradead.org>
Date: Wed, 30 Jul 2014 14:02:32 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, peterz@infradead.org, mingo@kernel.org
CC: jason.low2@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip v2 6/7] locking: Move docs into Documentation/locking/
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com> <1406752916-3341-6-git-send-email-davidlohr@hp.com>
In-Reply-To: <1406752916-3341-6-git-send-email-davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/14 13:41, Davidlohr Bueso wrote:
> Specifically:
>   Documentation/locking/lockdep-design.txt
>   Documentation/locking/lockstat.txt
>   Documentation/locking/mutex-design.txt
>   Documentation/locking/rt-mutex-design.txt
>   Documentation/locking/rt-mutex.txt
>   Documentation/locking/spinlocks.txt
>   Documentation/locking/ww-mutex-design.txt
> 
> Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>

Did you read and use Documentation/SubmittingPatches?  see:

Please use "git diff -M --stat --summary" to generate the diffstat:
the -M enables rename detection, and the summary enables a summary of
new/deleted or renamed files.

With rename detection, the statistics are rather different [...]
because git will notice that a fair number of the changes are renames.



We really want to see the renames when possible.  Otherwise it's good.

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  Documentation/00-INDEX                    |   2 +
>  Documentation/DocBook/kernel-locking.tmpl |   2 +-
>  Documentation/lockdep-design.txt          | 286 -----------
>  Documentation/locking/lockdep-design.txt  | 286 +++++++++++
>  Documentation/locking/lockstat.txt        | 178 +++++++
>  Documentation/locking/mutex-design.txt    | 157 ++++++
>  Documentation/locking/rt-mutex-design.txt | 781 ++++++++++++++++++++++++++++++
>  Documentation/locking/rt-mutex.txt        |  79 +++
>  Documentation/locking/spinlocks.txt       | 167 +++++++
>  Documentation/locking/ww-mutex-design.txt | 344 +++++++++++++
>  Documentation/lockstat.txt                | 178 -------
>  Documentation/mutex-design.txt            | 157 ------
>  Documentation/rt-mutex-design.txt         | 781 ------------------------------
>  Documentation/rt-mutex.txt                |  79 ---
>  Documentation/spinlocks.txt               | 167 -------
>  Documentation/ww-mutex-design.txt         | 344 -------------
>  MAINTAINERS                               |   4 +-
>  drivers/gpu/drm/drm_modeset_lock.c        |   2 +-
>  include/linux/lockdep.h                   |   2 +-
>  include/linux/mutex.h                     |   2 +-
>  include/linux/rwsem.h                     |   2 +-
>  kernel/locking/mutex.c                    |   2 +-
>  kernel/locking/rtmutex.c                  |   2 +-
>  lib/Kconfig.debug                         |   4 +-
>  24 files changed, 2005 insertions(+), 2003 deletions(-)
>  delete mode 100644 Documentation/lockdep-design.txt
>  create mode 100644 Documentation/locking/lockdep-design.txt
>  create mode 100644 Documentation/locking/lockstat.txt
>  create mode 100644 Documentation/locking/mutex-design.txt
>  create mode 100644 Documentation/locking/rt-mutex-design.txt
>  create mode 100644 Documentation/locking/rt-mutex.txt
>  create mode 100644 Documentation/locking/spinlocks.txt
>  create mode 100644 Documentation/locking/ww-mutex-design.txt
>  delete mode 100644 Documentation/lockstat.txt
>  delete mode 100644 Documentation/mutex-design.txt
>  delete mode 100644 Documentation/rt-mutex-design.txt
>  delete mode 100644 Documentation/rt-mutex.txt
>  delete mode 100644 Documentation/spinlocks.txt
>  delete mode 100644 Documentation/ww-mutex-design.txt


-- 
~Randy
