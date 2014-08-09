Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaHIQHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:07:39 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:61912 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaHIQHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:07:36 -0400
MIME-Version: 1.0
In-Reply-To: <53E63871.5040504@roeck-us.net>
References: <20140808213457.511493898@linuxfoundation.org>
	<53E57279.1030106@roeck-us.net>
	<20140809034911.GA2348@kroah.com>
	<20140809034950.GB2348@kroah.com>
	<53E5A0D1.10507@roeck-us.net>
	<20140809141609.GA21639@kroah.com>
	<53E63871.5040504@roeck-us.net>
Date: Sat, 9 Aug 2014 09:07:35 -0700
X-Google-Sender-Auth: 1VYYz1k4r3s0f4leYDGKA-OzXRI
Message-ID: <CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        satoru takeuchi <satoru.takeuchi@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 8:04 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> There are two arm build failures in Linus' tree which are not seen
> in -next.

Ugh. Did I screw up the semantic merge wrt the devm_phy_create()
argument changes despite having an example patch from Stephen? Or is
this something else due to something that just wasn't in -next?

Can you post the build failures?

          Linus
