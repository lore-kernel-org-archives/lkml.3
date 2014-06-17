Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbaFQFjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 01:39:22 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:45426 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbaFQFjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 01:39:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140617053332.GA9117@glanzmann.de>
References: <20140613095820.GA21162@glanzmann.de>
	<CACAvsv5dVMKcF67SO1qT=Foh4F0DkHeWNUztf8sQf++8GF-eMw@mail.gmail.com>
	<20140617053332.GA9117@glanzmann.de>
Date: Tue, 17 Jun 2014 15:39:19 +1000
Message-ID: <CACAvsv6nyu4cw6Yc1r5L8XNbS_Dyrka7o1JH=2Kc6URUWVcxjA@mail.gmail.com>
Subject: Re: [Nouveau] REGRESSION: Kernel PANIC 8777c5c11764d8336d8270f96778158c34c92108
 - drm/nouveau/dp: probe dpcd to determine connectedness
From: Ben Skeggs <skeggsb@gmail.com>
To: Ben Skeggs <skeggsb@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        nouveau <nouveau@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 3:33 PM, Thomas Glanzmann <thomas@glanzmann.de> wrote:
> Hello Ben,
>
>> Are you able to double-check that bisect?  I'm not at all sure how
>> that particular commit could trigger the issue you're seeing.  Some of
>> the others, certainly.  It might be worth trying a couple of times
>> before marking something as "good", in case there's a timing aspect to
>> the problem.
>
> please CC me, otherwise I might not see your message. The bug is very
> clear, I boot my machine, the screen turns black as soon as the X server
> is booted and the system does not ping anymore. I rebooted several times
> before the bisect and the bug always hit me. For my taste the offending
> commit is to large. So maybe I can split it in multiple smaller commits
> and than debug it. However I'm currently out of the office, so maybe
> tomorrow. If you do any progress on this, please CC me in order to avoid
> duplicate effort.
8777c5c11764d8336d8270f96778158c34c92108 (which is mentioned as the
first bad commit above...) is a tiny commit, so I have no idea what
you mean by "too large for your taste".

In any case, I encountered the oops myself earlier (absolutely nothing
to do with that commit) and fixed it here.  I've sent it onto Dave for
the next -fixes merge, so hopefully it'll help your case too.

Thanks,
Ben.

>
> Cheers,
>         Thomas
