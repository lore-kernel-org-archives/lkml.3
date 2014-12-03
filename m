Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaLCBed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:34:33 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:65095 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaLCBeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:34:31 -0500
MIME-Version: 1.0
In-Reply-To: <20141203013105.GA21642@kroah.com>
References: <1417533075-687-1-git-send-email-paul@mybb.com>
	<20141203004852.GA15236@kroah.com>
	<CAO7UptcspiZCNi8smcmhOWM9Rdn+QYHPJYmZb90A-_3sJ4wYqQ@mail.gmail.com>
	<20141203013105.GA21642@kroah.com>
Date: Tue, 2 Dec 2014 19:34:30 -0600
Message-ID: <CAO7Uptf=ThowWRogXcktj7wEK-3rTGOxNMb37YGWC-s5F6W9kQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: ft1000: fix spaces around comparisons in ft1000_debug.c
From: Paul H <paul@mybboard.net>
To: Greg KH <greg@kroah.com>
Cc: Paul H <paul@mybb.com>, Belisko Marek <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well shoot, please ignore what I just sent in then, I thought I had it.

-Paul

On Tue, Dec 2, 2014 at 7:31 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Dec 02, 2014 at 07:10:41PM -0600, Paul H wrote:
>> A tutorial I read suggested using a different branch for applying the
>> patches; I named it "fix-spaces".  It would appear it is mistaken
>> then?
>
> You have to make your patch against the linux-next tree, not Linus's
> tree, so as to not duplicate other people's work that has already been
> accepted.
>
> You can name your branch whatever you want to, that doesn't matter :)
>
> greg k-h
