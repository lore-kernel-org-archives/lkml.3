Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaAJJhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:37:50 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:40026 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaAJJhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:37:48 -0500
MIME-Version: 1.0
In-Reply-To: <CAB5gots=bzyQePOdJOpd9Pj=qgPsH0H8sAbxAQT+6UzmE-uVpQ@mail.gmail.com>
References: <CAB5gotu-bg2rXf-ObS+Hup5+Rf+PRxGByKtGGuE3AigsFCacgQ@mail.gmail.com>
	<CAB5gots8yDaQtCLFbYFQAzKc1zAWD7fhWtkStWdmt=uuEx_xPQ@mail.gmail.com>
	<CAB5gotvyFm3Vz=vEu90bC4hQdTdGM3Jdz9KY-kBzeF=gZddoAg@mail.gmail.com>
	<CAB5gots=bzyQePOdJOpd9Pj=qgPsH0H8sAbxAQT+6UzmE-uVpQ@mail.gmail.com>
Date: Fri, 10 Jan 2014 17:31:09 +0800
X-Google-Sender-Auth: 9oeItQ8Vvd7I64Ri4e4KFGG-q08
Message-ID: <CA+55aFyMOBjD+sDwFEwWnufKdJ0E31ggK5M5tTzrt0Zh3Q829g@mail.gmail.com>
Subject: Re: BUG() triggered in do_exit()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mind posting the actual bug message, and preferably a way to trigger it?

               Linus

On Fri, Jan 10, 2014 at 11:57 AM, Vaibhav Shinde
<v.bhav.shinde@gmail.com> wrote:
> Dear All,
>
> I faced this issue on kernel 3.8.13 -
>
> Background -
> An application created SIGSEGV 3 times, whose handling was done properly.
> At generation of SIGSEGV, the do_coredump() failed all 3 times due to
> failure in __get_dumpable () .
>
> The application was again started but this time we didn't get SIGSEGV, the
> BUG () in do_exit was triggered.
> That means schedule () function was failed.
>
> Could you tell the possible reasons for failure in schedule () and
> triggering BUG () in do_exit() ??
