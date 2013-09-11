Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535Ab3IKLsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:48:32 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61040 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3IKLsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAO_48GFa5t2A7t0z5Hj32V9mEE4fi9Whp7QcKxBX5aYTOfeGjw@mail.gmail.com>
References: <CAO_48GFa5t2A7t0z5Hj32V9mEE4fi9Whp7QcKxBX5aYTOfeGjw@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 11 Sep 2013 17:18:10 +0530
Message-ID: <CAO_48GH1Jp1yNdYm0n1_kSmuhLvuTm3H1CmDqd_fX7Dvwbjmcg@mail.gmail.com>
Subject: Re: [GIT PULL]: dma-buf updates for 3.12
To: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        linux-media@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Vetter <daniel@ffwll.ch>,
        Arnd Bergmann <arnd@arndb.de>, Dave Airlie <airlied@linux.ie>,
        Tom Gall <tom.gall@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.

Sincere apologies for the html post; this request is now in
plain-text. (it has been convenient using the gmail interface, but I
promise this is the last time you'll see a non-plain-text email from
me.

Apologies again!

Best regards,
~Sumit.

On 11 September 2013 17:07, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> Hi Linus,
>
> Here's the 3.12 pull request for dma-buf framework updates. Its yet another
> small one - dma-buf framework now supports size discovery of the buffer via
> llseek.
>
> Could you please pull?
>
> Thanks and best regards,
> ~Sumit.
>
>
> The following changes since commit 26b0332e30c7f93e780aaa054bd84e3437f84354:
>
>   Merge tag 'dmaengine-3.12' of
> git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine (2013-09-09
> 18:07:15 -0700)
>
> are available in the git repository at:
>
>
>   git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git tags/for-3.12
>
> for you to fetch changes up to 19e8697ba45e7bcdb04f2adf6110fbf4882863e5:
>
>   dma-buf: Expose buffer size to userspace (v2) (2013-09-10 11:36:45 +0530)
>
> ----------------------------------------------------------------
> dma-buf updates for 3.12
>
> ----------------------------------------------------------------
> Christopher James Halse Rogers (1):
>       dma-buf: Expose buffer size to userspace (v2)
>
> Tuomas Tynkkynen (1):
>       dma-buf: Check return value of anon_inode_getfile
>
>  Documentation/dma-buf-sharing.txt | 12 ++++++++++++
>  drivers/base/dma-buf.c            | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+)
>
