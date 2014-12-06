Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703AbaLFDzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:55:20 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:38513 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaLFDzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:55:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAE2SPAa3FZz6MH41UB-CmruFw0kCTq=KS5MkNXMaiEidpSGkSg@mail.gmail.com>
References: <1417597255-32530-1-git-send-email-oakad@yahoo.com>
	<1417597255-32530-2-git-send-email-oakad@yahoo.com>
	<CAE2SPAa3FZz6MH41UB-CmruFw0kCTq=KS5MkNXMaiEidpSGkSg@mail.gmail.com>
Date: Sat, 6 Dec 2014 14:55:18 +1100
Message-ID: <CAPs88r90jSv=zOeMqxXpFp0nXbSaHnoKFApr9jE1mJr92dOr3w@mail.gmail.com>
Subject: Re: [PATCH] syscall: introduce sendfd() syscall (v.2)
From: Alex Dubov <alex.dubov@gmail.com>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: Alex Dubov <oakad@yahoo.com>, Richard Cochran <richardcochran@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 6, 2014 at 6:23 AM, Bastien ROUCARIES
<roucaries.bastien@gmail.com> wrote:
>
>
> See senfd recvfd in gnulib. It wirk even under solaris
>

What's so special about a thin wrapper around domain sockets/named
fifos (solaris style)?
