Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaAVBvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 20:51:15 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:33781 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaAVBvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 20:51:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140121094814.GB6928@htj.dyndns.org>
References: <20140121094814.GB6928@htj.dyndns.org>
Date: Tue, 21 Jan 2014 17:51:13 -0800
X-Google-Sender-Auth: 27yw7IATz2nyvPZCKxJUginNltw
Message-ID: <CA+55aFy6k0ezh69eXGDAJPfKHDRLPurCUBKXW4pcV-UjQVGLmg@mail.gmail.com>
Subject: Re: [GIT PULL] percpu changes for v3.14-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 1:48 AM, Tejun Heo <tj@kernel.org> wrote:
>
> I messed up the for-3.14 branch (committed stuff to for-next) and had
> to rebuild for-3.14 by cherry-picking; however, the result is the same
> as published to the next tree through for-next.
>
> The changes are available in the following git branch
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git

You messed up the pull request too.. The branch name is missing from
that git line, even if you did mention it a few lines earlier...

              Linus
