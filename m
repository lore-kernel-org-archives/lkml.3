Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaLCOIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:08:47 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:58279 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaLCOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141203104144.GA7495@localhost.localdomain>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-2-git-send-email-oakad@yahoo.com>
	<20141202170037.GG29748@ZenIV.linux.org.uk>
	<CAPs88r8m2QmaOWy623swGk=T3cyG85X3N7Z9tAp3nZvD0Tch+A@mail.gmail.com>
	<1417589446.5303.121.camel@edumazet-glaptop2.roam.corp.google.com>
	<20141203080800.GB5193@localhost.localdomain>
	<CAFLxGvzZQ59BRdWiPyVhCEUrR2UD3Ozdg2DHzRUqNQocf9o-EA@mail.gmail.com>
	<20141203104144.GA7495@localhost.localdomain>
Date: Thu, 4 Dec 2014 01:08:45 +1100
Message-ID: <CAPs88r8EMkLD1B7K7QYwGvjFUjNcc9t9=gQma9FQbcYgK3vrxA@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: introduce sendfd() syscall
From: Alex Dubov <alex.dubov@gmail.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 9:41 PM, Richard Cochran
<richardcochran@gmail.com> wrote:
> In any case, I find it hard to believe that the traditional method is
> really so bad. The explanation of why this new way is needed boils
> down to: "unix programming is so hard to get right."


Surely, this can be said about any new feature proposed. Why do we
need this new thing called wheel? We lived 50k years without it just
fine! It all boils down to: "walking with legs is so hard to get
right". :-)
