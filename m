Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaLEKoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:44:38 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:43373 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaLEKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:44:36 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1417715473-24110-5-git-send-email-pieter@boesman.nl>
References: <1417715473-24110-1-git-send-email-pieter@boesman.nl>
	<1417715473-24110-5-git-send-email-pieter@boesman.nl>
Date: Fri, 5 Dec 2014 11:44:36 +0100
Message-ID: <CAJfpegu+NQQ_+af=6UXi2=fyTJK1CsQBZ2++Nysu4mume4UEOQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/7] fs/fuse: support compiling out splice
From: Miklos Szeredi <miklos@szeredi.hu>
To: Pieter Smith <pieter@boesman.nl>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        "open list:ABI/API" <linux-api@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 6:50 PM, Pieter Smith <pieter@boesman.nl> wrote:
> To implement splice support, fs/fuse makes use of nosteal_pipe_buf_ops. This
> struct is exported by fs/splice. The goal of the larger patch set is to
> completely compile out fs/splice, so uses of the exported struct need to be
> compiled out along with fs/splice.
>
> This patch therefore compiles out splice support in fs/fuse when
> CONFIG_SYSCALL_SPLICE is undefined.
>
> Signed-off-by: Pieter Smith <pieter@boesman.nl>


In the future could you PLEASE PLEASE cut the fuse-devel Cc from the
non-fuse specific patches (and I guess that goes for any other
subsystem specific lists and persons as well)?

Otherwise:

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

Thanks,
Miklos
