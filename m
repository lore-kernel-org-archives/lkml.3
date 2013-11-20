Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3KTAnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 19:43:15 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36136 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3KTAnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 19:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <20131120003032.GA27825@kroah.com>
References: <20131017211236.GA6155@kroah.com>
	<1383850796-24300-1-git-send-email-peter@hurleysoftware.com>
	<CA+55aFwYps=q14pQ04yWYThFwi3NnR__MeggU8N3M4Q0vrk+nQ@mail.gmail.com>
	<20131120003032.GA27825@kroah.com>
Date: Tue, 19 Nov 2013 16:43:10 -0800
X-Google-Sender-Auth: -_P0A2HvE1W8fA4DgmaTOeBk0QI
Message-ID: <CA+55aFzbOsV_3JGV5LQe957TJ1rnEckv+e7qQNLp9ctOYa6EHg@mail.gmail.com>
Subject: Re: [PATCH] n_tty: Ensure reader restarts worker for next reader
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, "# .39.x" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 4:30 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I was waiting for 3.13-rc1 to be out to populate my trees and then send
> it on to you.
>
> But if you want to take it now, great, I have no objection, otherwise I
> was going to wait till next week.

I don't care deeply - it's marled for stable, but the race it fixes is
so unlikely as to be almost irrelevant, so it's not like I need it
now.

I was just going through emails that came in during travel, and making
sure it's not lost.

So I'll happily forget about it, knowing that it is in your queue.

                 Linus
