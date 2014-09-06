Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaIFXDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 19:03:00 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:65191 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaIFXC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 19:02:59 -0400
MIME-Version: 1.0
In-Reply-To: <540B8040.5010206@gmail.com>
References: <540B8040.5010206@gmail.com>
Date: Sun, 7 Sep 2014 01:02:58 +0200
Message-ID: <CAFLxGvx7-KR7JqeH3d5nZ6prSez-32BVq6-SNot3s+Nw=UBVhg@mail.gmail.com>
Subject: Re: /proc/<pid>/exe symlink behavior change in >=3.15.
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Piotr Karbowski <piotr.karbowski@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 6, 2014 at 11:44 PM, Piotr Karbowski
<piotr.karbowski@gmail.com> wrote:
> Hi,
>
> Starting with kernel 3.15 the 'exe' symlink under /proc/<pid>/ acts diffrent
> than it used to in all the pre-3.15 kernels.
>
> The usecase:
>
> run /root/testbin (app that just sleeps)
> cp /root/testbin /root/testbin.new
> mv /root/testbin.new /root/testbin
> ls -al /proc/`pidof testbin`/exe
>
> <=3.14: /root/testbin (deleted)
>>=3.15: /root/testbin.new (deleted)
>
> Was the change intentional? It does render my system unusable and I failed
> to find a information about such change in the ChangeLog.

Can you please find the offending commit?
Using an automated bisect run this should be easily doable.

-- 
Thanks,
//richard
