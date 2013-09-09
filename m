Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3IIDjP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:39:15 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47745 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3IIDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <522D3EA6.3010301@roeck-us.net>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
 <20130909023311.GB5329@kroah.com> <CALkWK0mLUfJL0s-OxrmAD_RXpv0Qs-j23XedwPGAHKTq4JJjcA@mail.gmail.com>
 <20130909025030.GA5963@kroah.com> <CALkWK0kL0z1kTgp6N4mNt65GN4nwwL9EaBg=7XVVCsy2zJyj7A@mail.gmail.com>
 <522D3EA6.3010301@roeck-us.net>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 09:08:33 +0530
Message-ID: <CALkWK0=6J-hk77pD=A=8Ua6O+XcW8oowsRJkKKPbUCHNkNJuEw@mail.gmail.com>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and XTENSA
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        Peng Tao <tao.peng@emc.com>, Peng Tao <bergwolf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter Roeck wrote:
>> For stability, hardware needs to be present. When I started out a
>> couple of days ago, I blamed my monitor for the data corruption: it's
>> one extra point of leverage.
>
> I have no idea whatsoever what you are talking about.

Sorry, my bad. I haven't done hardware driver development.
