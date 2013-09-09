Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3IICzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:55:53 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51935 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3IICzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:55:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130909025030.GA5963@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
 <20130909023311.GB5329@kroah.com> <CALkWK0mLUfJL0s-OxrmAD_RXpv0Qs-j23XedwPGAHKTq4JJjcA@mail.gmail.com>
 <20130909025030.GA5963@kroah.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 08:25:12 +0530
Message-ID: <CALkWK0kL0z1kTgp6N4mNt65GN4nwwL9EaBg=7XVVCsy2zJyj7A@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman wrote:
>> How will the hardware industry be driven otherwise?
>
> I have no idea what you are referring to here, please explain.

For stability, hardware needs to be present. When I started out a
couple of days ago, I blamed my monitor for the data corruption: it's
one extra point of leverage.

Ram
