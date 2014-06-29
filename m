Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaF2U2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 16:28:31 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37824 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaF2U2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 16:28:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140629191254.GA13271@pd.tnic>
References: <CAC-LjFtjS5RS9=Lvb090-0aEnSdR1a28Scve2gvTR3yAZtt+9g@mail.gmail.com>
 <20140629191254.GA13271@pd.tnic>
From: Jeshwanth Kumar N K <jeshkumar555@gmail.com>
Date: Mon, 30 Jun 2014 01:58:08 +0530
Message-ID: <CAC-LjFsF1qAVPKJeYmR0+6wTVmCwo2TkC8bia-KmxQ3wyUXYaw@mail.gmail.com>
Subject: Re: [BUG] User process tainting in linux-next tree
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Borislav,

Yes booted by increase the buffer length, but the ignore_loglevel is
running continously for 5 minutes. So I ignored that and ran with
log_buf_len=500M ( because 10M also filled) only.

When I copied the dmesg, the size was 76M, so I attached only first
1500 lines. Please find in below link.

https://bugzilla.kernel.org/show_bug.cgi?id=79171


On Mon, Jun 30, 2014 at 12:42 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Jun 29, 2014 at 11:48:02PM +0530, Jeshwanth Kumar N K wrote:
>> Hello,
>>
>>  I have created a bug in bugzilla
>> https://bugzilla.kernel.org/show_bug.cgi?id=79171 , The native built
>> Linux-next kernel is giving tainted Error. Can you please give me a
>> pointer to solve this?
>
> All those dmesg log files you've uploaded are incomplete and truncated
> from the beginning and we want to see them from the beginning because
> there is the first warning which is almost always the most important
> one.
>
> For that, boot your kernel with "log_buf_len=10M ignore_loglevel" and
> then collect full dmesg by doing
>
> dmesg > dmesg.log
>
> which you can then upload to the bugzilla again.
>
> Also, please try a newer linux-next tree or Linus' tree.
>
> HTH.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --



-- 
Regards
Jeshwanth Kumar N K
Bangalore, India
