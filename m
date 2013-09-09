Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3IICjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 22:39:10 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59157 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3IICjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 22:39:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130909023311.GB5329@kroah.com>
References: <1378688580-11935-1-git-send-email-linux@roeck-us.net>
 <20130909015945.GA4029@kroah.com> <CALkWK0kx+71O074dfP4ikj4FayU6GWXOByTFPgVjv=CVO-btUQ@mail.gmail.com>
 <20130909023311.GB5329@kroah.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 08:08:28 +0530
Message-ID: <CALkWK0mLUfJL0s-OxrmAD_RXpv0Qs-j23XedwPGAHKTq4JJjcA@mail.gmail.com>
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
> What do you mean by this?  What "initial cost"?  You should be able to
> cross-compile almost all arches on your desktop machine today with the
> compilers we have on kernel.org.  If I can get them set up and working,
> they can't be that hard for anyone else :)

Won't you need to physically explore hardware? How will the hardware
industry be driven otherwise?
