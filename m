Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaLBOb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 09:31:58 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47317 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaLBOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 09:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <547DA592.7090900@monstr.eu>
References: <1417494919-4577-1-git-send-email-oakad@yahoo.com>
	<1417494919-4577-3-git-send-email-oakad@yahoo.com>
	<CAMuHMdWWnO7m8f+NnM8Xahexc+3ELeAgTDv67CzWWEZENqztEA@mail.gmail.com>
	<547DA592.7090900@monstr.eu>
Date: Wed, 3 Dec 2014 01:31:56 +1100
Message-ID: <CAPs88r_6V_O_j8SrXAdkRZgLn=0BfZksK3e9=9xQGsjrqSZ+Zw@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Wire up sendfd() syscall (all architectures)
From: Alex Dubov <alex.dubov@gmail.com>
To: monstr@monstr.eu
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Dubov <oakad@yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 10:42 PM, Michal Simek <monstr@monstr.eu> wrote:
> On 12/02/2014 09:01 AM, Geert Uytterhoeven wrote:
>> This really needs a CC to linux-arch (added).
>>
>> On Tue, Dec 2, 2014 at 5:35 AM, Alex Dubov <alex.dubov@gmail.com> wrote:
>>> Signed-off-by: Alex Dubov <oakad@yahoo.com>
>>> ---

>
> The same for microblaze here
> arch/microblaze/include/asm/unistd.h
>

This invites the question as to why the __NR_syscalls macro is not
defined in uapi/asm/unistd.h on those architectures, where it will be
easier to spot? After all, asm/unistd.h includes uapi/asm/unistd.h
unconditionally.
