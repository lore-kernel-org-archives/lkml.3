Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaA2Ung (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:43:36 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42748 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaA2Und (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
Date: Wed, 29 Jan 2014 22:43:28 +0200
Message-ID: <CALFYKtCtTTuDwzFYdPHiNLh92iNjeTizVD6h4Q=DNuES+d_g0A@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Sage Weil <sage@inktank.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 6:37 PM, Ilya Dryomov <ilya.dryomov@inktank.com> wrote:
> From: Sage Weil <sage@inktank.com>
>
> The merge of 7221fe4c2 raced with upstream changes in the generic POSIX
> ACL code (2aeccbe95).  Update Ceph to use the new helpers as well by
> dropping the now-generic functions and setting the set_acl inode op.
>
> Signed-off-by: Sage Weil <sage@inktank.com>

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>

Thanks,

                Ilya
