Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3AUW5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:57:09 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:59164 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab3AUW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:57:08 -0500
MIME-Version: 1.0
In-Reply-To: <18379918.sbmR7uiKVn@vostro.rjw.lan>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<2462618.rQxKXSuBtr@vostro.rjw.lan>
	<CAPPqfY3vZX3a-GONmzoWdn7sp=_pzKL2qAKBxYZ9ABNLetKoag@mail.gmail.com>
	<18379918.sbmR7uiKVn@vostro.rjw.lan>
Date: Mon, 21 Jan 2013 23:57:06 +0100
Message-ID: <CAPPqfY2umN2Fab=APyt4=LM32x2av7nPruADX3dddTxdWG2Umg@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good evening,

>> I'll try to track this commit.
>
> Thanks a lot!

I failed to find a working version today with CONFIG_PM=y
(tested 3.2.6, 3.2.5, 3.2.0, 3.0.1, 2.6.32.8). I'll try older kernels tomorrow.

I'm very sceptical now : how can a bug with such a big impact (25%
performance drop) can survive for so many years, with no one seeing it
?
Good point is that benchmark can be easily done (it took less than an
hour to test a new version). If you have patches to be tested, feel
free to ask :)

In the meanwhile, do you think I can compile a working 3.7 kernel ?
Maybe by activating / deactivating specific options ?

Olivier
