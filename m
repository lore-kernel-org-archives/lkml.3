Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaLCCLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:11:30 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35219 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaLCCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:11:29 -0500
MIME-Version: 1.0
In-Reply-To: <1417538574.5303.69.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
	<1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
	<CAPs88r-jZ5FvCHQjArKXhpX1YRg3O4NdUFtLizraF6nZ9SjFKw@mail.gmail.com>
	<1417538574.5303.69.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Wed, 3 Dec 2014 13:11:28 +1100
Message-ID: <CAPs88r_5GYAmWhW9rwj8c6oAjy8RZYih2mBubgvqRXfcgiUzYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 3:42 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Wed, 2014-12-03 at 03:23 +1100, Alex Dubov wrote:
>
> Tell me how a 128 threads program can use this new mechanism in a
> scalable way.
>
> One signal per thread ?

What for?

Kernel will deliver the signal only to the thread/threads which has
the relevant signal unblocked (they are blocked by default).

>
> I guess we'll keep AF_UNIX then, thank you.

Kindly enlighten me, how are you going to use any file descriptor in a
128 threads program in a scalable way (socket and all)? How this
approach will be different when using signalfd()?

And no, I'm not proposing to take your favorite toys away.
