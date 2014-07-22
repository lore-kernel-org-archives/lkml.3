Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaGVROz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 13:14:55 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36194 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbaGVROy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 13:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVhUkF49L1jJgfXdRdMW2qkGsbPfGVwrdaETqTUs3bEcsQ@mail.gmail.com>
References: <CAPDOMVhUkF49L1jJgfXdRdMW2qkGsbPfGVwrdaETqTUs3bEcsQ@mail.gmail.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 22 Jul 2014 10:14:13 -0700
Message-ID: <CAGVrzcb665srrVTojY+E1Raec5=E6oK+CAdPrP3Fx15Zt+piBQ@mail.gmail.com>
Subject: Re: decompress.c : Add cache support
To: Nick Krause <xerofoify@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Antony Pavlov <antonynpavlov@gmail.com>,
        John Crispin <blogic@openwrt.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-21 21:24 GMT-07:00 Nick Krause <xerofoify@gmail.com>:
> Hey Ralf and others
> We seem to be flushing this cache after decompressing the kernel on
> mips. Can't we cache this?

I am not sure I fully understand what you mean here. What would we be
caching, instruction, data, both?

> If anyone has any advice on how to fix this it would be great:).
> Nick

One patch that I carried locally and which works for a bunch of
MIPS32r1 compatible platforms out there is this one, I tried to
address some of Ralf's comment as well about the code duplication
(maybe I can get around to resubmit it):

http://patchwork.linux-mips.org/patch/1565/
-- 
Florian
