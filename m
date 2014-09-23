Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaIWFWt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:22:49 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60308 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbaIWFWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140919104021.GA11552@gmail.com>
References: <20140919104021.GA11552@gmail.com>
Date: Mon, 22 Sep 2014 22:22:47 -0700
X-Google-Sender-Auth: bsOSp1ujHidEbuw4u7ZYEdaa1lE
Message-ID: <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 3:40 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> Please pull the latest x86-urgent-for-linus git tree from:

I only just noticed, but this pull request causes my Sony Vaio laptop
to immediately reboot at startup.

I'm assuming it's one of the efi changes, but I'm bisecting now to say
exactly where it happens. It will get reverted.

             Linus
