Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbaLBQm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:42:58 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36375 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:42:57 -0500
Message-ID: <1417538574.5303.69.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alex Dubov <alex.dubov@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Date: Tue, 02 Dec 2014 08:42:54 -0800
In-Reply-To: <CAPs88r-jZ5FvCHQjArKXhpX1YRg3O4NdUFtLizraF6nZ9SjFKw@mail.gmail.com>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	 <1417494919-4577-2-git-send-email-oakad@yahoo.com>
	 <1417524607.5303.45.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r_Dz+UqwhqAcKwXuLZGz4n=NocD-0FuOZug5UGH64p_8w@mail.gmail.com>
	 <1417534380.5303.64.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAPs88r-jZ5FvCHQjArKXhpX1YRg3O4NdUFtLizraF6nZ9SjFKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 03:23 +1100, Alex Dubov wrote:

> Same as SIGKILL. And yet, our machines are still working fine.
> 
> If process A has sufficient capability to send signals to process B,
> then process B is already at its mercy, fds or not fds.

Tell me how a 128 threads program can use this new mechanism in a
scalable way.

One signal per thread ?

I guess we'll keep AF_UNIX then, thank you.


