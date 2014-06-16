Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaFPRZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:25:48 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56321 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaFPRZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
References: <539F1C59.6070308@gmx.de> <CAFLxGvyqPzbmfz1-WxP7z02=V-V5=p5b09HYPOFOS7Qj8eUHGw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 16 Jun 2014 10:25:26 -0700
Message-ID: <CALCETrXqjHPvKw=wcdnxQWO0Y140B=a0E7eh4+PoERvU=z909w@mail.gmail.com>
Subject: Re: 3.15: kernel BUG at kernel/auditsc.c:1525!
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:21 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Jun 16, 2014 at 6:33 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
>> $ cat syscall.c
>> #include <unistd.h>
>> #include <sys/syscall.h>
>> int main(){return syscall(1000)!=-1;}

What architecture are you building for?  On i386 and x86_64, 1000
shouldn't be big enough to trigger this.

--Andy
