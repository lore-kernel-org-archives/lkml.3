Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JGDRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 23:17:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:34730 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3JGDRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 23:17:23 -0400
Message-ID: <525227C0.6040601@lwfinger.net>
Date: Sun, 06 Oct 2013 22:17:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alex Dubov <oakad@yahoo.com>, Catalin Marinas <catalin.marinas@arm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error path
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net> <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com> <5251FA23.1080504@lwfinger.net> <1381111070.35370.YahooMailNeo@web161301.mail.bf1.yahoo.com>
In-Reply-To: <1381111070.35370.YahooMailNeo@web161301.mail.bf1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 08:57 PM, Alex Dubov wrote:
> Hi,
>
> In the good old times, when this driver was first written, device name used to be a fixed
> size array (of 32 chars, if I'm not mistaken) in the kobj struct, so there was no need to
> free it explicitly.
>
> Since than, somebody changed the name field to become a loose pointer, but it's not
> obvious how it is supposed to be handled these days.

It has been some time since it was changed. In commit af5ca3f by Kay Sievers and 
merged on Dec 20, 2007, "const char *k_name" was changed to "const char *name". 
I did not go any further back.

I'll submit V2 of my patch for further comment.

Larry



