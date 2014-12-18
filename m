Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaLRCy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:54:57 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:65080 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaLRCy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:54:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAAM7YAk-izpgFZGBoSO7P1VMXLO5i4ezSrPM4E4f7eFCw=f+3w@mail.gmail.com>
References: <alpine.DEB.2.00.1412171520460.5263@cobra.newdream.net>
	<CAAM7YAk-izpgFZGBoSO7P1VMXLO5i4ezSrPM4E4f7eFCw=f+3w@mail.gmail.com>
Date: Wed, 17 Dec 2014 18:54:55 -0800
X-Google-Sender-Auth: YBJcNzkNp2JLY04jyBhSosN4j8w
Message-ID: <CA+55aFwf7znK=EFGbF6NN14mPuFL-1GjzZffNVU_+qj52oaKkg@mail.gmail.com>
Subject: Re: [GIT PULL] Ceph updates for 3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Yan, Zheng" <ukernel@gmail.com>
Cc: Sage Weil <sweil@redhat.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 6:25 PM, Yan, Zheng <ukernel@gmail.com> wrote:
> my commit "ceph: add inline data to pagecache"  incidentally adds
> fs/ceph/super.j.rej.  please remove it from your branch.  sorry for
> the inconvenience

I wish I hadn't pulled it so quickly, and could have fixed it up as
part of the merge commit, but I pushed a separate commit to remove it.

                 Linus
