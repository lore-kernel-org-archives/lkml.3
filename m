Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab3GWUmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 16:42:49 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:36998 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3GWUms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 16:42:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130723190855.GA509@polaris.bitmath.org>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	<20130723010437.GA570@polaris.bitmath.org>
	<1374542261.7972.66.camel@leira.trondhjem.org>
	<1374604305.12943.3.camel@leira.trondhjem.org>
	<20130723190855.GA509@polaris.bitmath.org>
Date: Tue, 23 Jul 2013 13:42:47 -0700
X-Google-Sender-Auth: Z7-_NkelulKkvTji-KzN5e7J44c
Message-ID: <CA+55aFwpwJ3MgVtbNZQXjCV+06xq1xk=XO1OYwoscvO3SQth3A@mail.gmail.com>
Subject: Re: Linux 3.11-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andre Heider <a.heider@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 12:08 PM,  <rydberg@euromail.se> wrote:
> Hi Trond,
>
>> OK. With Andre's help, I think we've root caused the problem. Can you
>> please confirm that the attached patch also solves the issue for you?
>
> Seems to work fine,
>
>    Reported-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Trond, do you have anything else pending and are planning a git pull,
or should I just take this patch directly?

               Linus
