Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3LSBee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:34:34 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:46328 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3LSBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:34:33 -0500
MIME-Version: 1.0
In-Reply-To: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
Date: Wed, 18 Dec 2013 17:34:31 -0800
Message-ID: <CAPcyv4gBN4M312WRmAvwHbTjMspiSTPuFyir_fc3nH6akpgosw@mail.gmail.com>
Subject: Re: [PATCH] closures: move to lib/
From: Dan Williams <dan.j.williams@intel.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 5:29 PM, Kent Overstreet <kmo@daterainc.com> wrote:
> the closure code was never intended to be bcache specific - hopefully it can be
> useful elsewhere in the kernel.
>
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/md/bcache/Kconfig   |   9 -
>  drivers/md/bcache/Makefile  |   2 +-
>  drivers/md/bcache/bcache.h  |   2 +-
>  drivers/md/bcache/closure.c | 222 ----------------------
>  drivers/md/bcache/closure.h | 453 --------------------------------------------
>  drivers/md/bcache/util.h    |   3 +-
>  include/linux/closure.h     | 451 +++++++++++++++++++++++++++++++++++++++++++
>  lib/Kconfig.debug           |   8 +
>  lib/Makefile                |   2 +-
>  lib/closure.c               | 218 +++++++++++++++++++++
>  10 files changed, 681 insertions(+), 689 deletions(-)
>  delete mode 100644 drivers/md/bcache/closure.c
>  delete mode 100644 drivers/md/bcache/closure.h
>  create mode 100644 include/linux/closure.h
>  create mode 100644 lib/closure.c

This would be smaller to review with git diff -M
