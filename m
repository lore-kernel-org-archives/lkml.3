Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484Ab3GPQEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 12:04:38 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44169 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab3GPQEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 12:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <51E56DCB.3040108@nod.at>
References: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com>
 <51E56DCB.3040108@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 16 Jul 2013 21:33:56 +0530
Message-ID: <CALkWK0kFJnDvsPy1HRzut7bxwXhLRQ0qivvy861S77Q6bhjrCQ@mail.gmail.com>
Subject: Re: [QUERY] User-Mode Linux and /dev/tty*
To: Richard Weinberger <richard@nod.at>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> UML does not have CONFIG_VT.

Not sure what this means.

> But recent systemd versions can deal with that.

Nope, running systemd HEAD.  I only recently figured out how to detect
that um Linux is running [1].

[1]: https://github.com/systemd/systemd/commit/7080ea16
