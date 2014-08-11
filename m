Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHKIAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:00:55 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49554 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaHKIAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:00:54 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyo3S=4fWO0x5we_Fs9O28+ohOfo9JFGNCqwat2D89fJA@mail.gmail.com>
References: <CADDKRnDD_W5yJLo2otWXH8oEgmGdMP0N_p7wenBQbh17xKGZJg@mail.gmail.com>
	<CA+55aFzDpH8ntPO=JMdJ4Pu-SFV=9HQsXBcPakrZZq2mE9rJsA@mail.gmail.com>
	<8761i0hzzn.fsf@x220.int.ebiederm.org>
	<CA+55aFyo3S=4fWO0x5we_Fs9O28+ohOfo9JFGNCqwat2D89fJA@mail.gmail.com>
Date: Mon, 11 Aug 2014 10:00:53 +0200
Message-ID: <CADDKRnAtSOAdMsoZtWnM7HuoSdv6ipGDquknyLpneuYsarkcsg@mail.gmail.com>
Subject: Re: [proc:] 3.16.0-10436-g9138475: access denied to /proc/1540/task/1540/net/dev
From: =?UTF-8?Q?J=C3=B6rg_Otte?= <jrg.otte@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-11 6:30 GMT+02:00 Linus Torvalds <torvalds@linux-foundation.org>:
> On Sun, Aug 10, 2014 at 1:05 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> Linus would you like me to send pull request with those two changes reverted?
>
> I just did them (delayed it a bit in the hope to get confirmation, but
> it looks very straightforward, so since I'll be on airplanes most of
> tomorrow..)
>
>              Linus

OK, Kernel: 3.16.0-10473-gc8d6637 fixes the problem for me.

Thanks,
Jörg
