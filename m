Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3KMTbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:31:14 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:37841 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab3KMTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:31:08 -0500
MIME-Version: 1.0
In-Reply-To: <1384302563.3665.28.camel@joe-AO722>
References: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
	<20131030134839.8bdf70cc68d1bf0beb1fb63a@linux-foundation.org>
	<1383244173.8740.9.camel@joe-AO722>
	<CA+8MBb+rrAWSTTvO4cx32ju-QOAG6aHHxR9B=sLtGXR3q8DF0A@mail.gmail.com>
	<1384302563.3665.28.camel@joe-AO722>
Date: Wed, 13 Nov 2013 11:31:06 -0800
Message-ID: <CA+8MBbJKN174=ybMNE7Z+oT7KjNBzgdy9cvhb_kACvXAbTo9XA@mail.gmail.com>
Subject: Re: [PATCH V3] printk/cache: Mark printk_once test variable __read_mostly
From: Tony Luck <tony.luck@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-metag@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 4:29 PM, Joe Perches <joe@perches.com> wrote:
> try this:
>
> https://lkml.org/lkml/2013/10/30/604
>
>

How is that any different from what is in linux-next?  It still
has the same change to cache.h that reduces the nested
#includes that currently make the build work.

-#include <linux/kernel.h>
+#include <uapi/linux/kernel.h>

-Tony
