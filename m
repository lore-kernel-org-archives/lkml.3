Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3KFQGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:06:38 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64208 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3KFQGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:06:36 -0500
MIME-Version: 1.0
In-Reply-To: <52715AD1.7000703@gmx.de>
References: <526696BF.6050909@gmx.de>
	<CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com>
	<5266A698.10400@gmx.de>
	<5266B60A.1000005@nod.at>
	<52715AD1.7000703@gmx.de>
Date: Wed, 6 Nov 2013 20:06:36 +0400
Message-ID: <CALYGNiPvJF1u8gXNcX1AZR5-VkGqJnaose84KBbdaoBAq8aoGQ@mail.gmail.com>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs in radix_tree_next_chunk()
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case it must stop after scanning whole tree in line:
/* Overflow after ~0UL */
if (!index)
  return NULL;
