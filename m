Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaL2QVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:21:25 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54532 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL2QVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:21:23 -0500
MIME-Version: 1.0
X-Originating-IP: [76.119.162.148]
In-Reply-To: <54A17C49.5080102@gmx.de>
References: <54A17C49.5080102@gmx.de>
Date: Mon, 29 Dec 2014 11:21:22 -0500
Message-ID: <CAHC9VhTT1WqGfuOLpXw1o2ZE5Bhwg35KCc1Gg2-bYtFX9jAYRg@mail.gmail.com>
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
From: Paul Moore <paul@paul-moore.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 11:07 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> A x86 KVM guest running at a 64 bit Gentoo hardened host system the following crashes appeared reproducible (screen shots attached.
>
> If I removed syslog-ng from the runlevel default, then the crash just appeared a little bit later at another subsystem

It looks like it doesn't like something in audit_compare_dname_path();
I'll take a look and see what I can find, there is a patch in -rc2
which touched some related code.

I didn't see this problem in my earlier testing, can you share your .config?

-- 
paul moore
www.paul-moore.com
