Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005Ab3ANStZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:49:25 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:33883 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3ANStX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:49:23 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <29967FDF21E24227AD4EC1DE00AC4044@VIU9IM6TKCWEEDX>
References: <29967FDF21E24227AD4EC1DE00AC4044@VIU9IM6TKCWEEDX>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Opening DEBUG in compressed/head.S,then kernel crashed
From: Domenico Andreoli <cavokz@gmail.com>
Date: Mon, 14 Jan 2013 19:14:35 +0100
To: zhaoyilong <registcn@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <216ac924-a227-4c7e-a492-6d55db1ff657@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zhaoyilong <registcn@gmail.com> wrote:

>    When I open the macro DEBUG in the front of  file 
>arch/arm/boot/decompressed/head.S,the kernel runs and stops
>at"Uncompressing 
>Linux... done, booting the kernel."

so the decompressor is able to write to the right console (and uncompress the kernel) but the kernel isn't.

with a bit of luck you could get something appending earlyprintk to the kernel command line.

cheers,
Dome



