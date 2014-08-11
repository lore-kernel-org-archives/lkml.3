Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaHKEan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 00:30:43 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33287 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaHKEam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 00:30:42 -0400
MIME-Version: 1.0
In-Reply-To: <8761i0hzzn.fsf@x220.int.ebiederm.org>
References: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
	<CA+55aFzDpH8ntPO=JMdJ4Pu-SFV=9HQsXBcPakrZZq2mE9rJsA@mail.gmail.com>
	<8761i0hzzn.fsf@x220.int.ebiederm.org>
Date: Sun, 10 Aug 2014 21:30:41 -0700
X-Google-Sender-Auth: kjwfD-YUQ_OoYpvGEBf7df1VviQ
Message-ID: <CA+55aFyo3S=4fWO0x5we_Fs9O28+ohOfo9JFGNCqwat2D89fJA@mail.gmail.com>
Subject: Re: [proc:] 3.16.0-10436-g9138475: access denied to /proc/1540/task/1540/net/dev
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 1:05 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Linus would you like me to send pull request with those two changes reverted?

I just did them (delayed it a bit in the hope to get confirmation, but
it looks very straightforward, so since I'll be on airplanes most of
tomorrow..)

             Linus
