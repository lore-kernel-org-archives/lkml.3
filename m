Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab3DPOz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 10:55:28 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36688 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3DPOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 10:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130416162047.2f9b83fe.skraw@ithnet.com>
References: <20130416162047.2f9b83fe.skraw@ithnet.com>
Date: Tue, 16 Apr 2013 16:55:25 +0200
Message-ID: <CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
Subject: Re: No serial since kernel 3.8
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Stephan von Krawczynski <skraw@ithnet.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 4:20 PM, Stephan von Krawczynski
<skraw@ithnet.com> wrote:
> Hello,
>
> can some kind soul please explain how I can get my serial port back under
> kernel 3.8.X. Earlier kernels showed:
>
> Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
> (irq = 4) is a 16550A
>
> But 3.8.4:
>
> Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled
>
> Only kernel is replaced, no change in distro
> Is there some kernel boot parameter needed now?
> I tried 3.4.X and it works, even 3.7.X works...

So, 3.8.3 worked and 3.8.4 introduced a regression?
If so please confirm.

CC'ing gregkh, just in case...

--
Thanks,
//richard
