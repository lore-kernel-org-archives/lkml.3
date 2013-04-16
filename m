Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab3DPPAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:00:13 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:36878 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3DPPAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:00:11 -0400
Date: Tue, 16 Apr 2013 10:59:53 -0400
From: Josh Boyer <jwboyer@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: No serial since kernel 3.8
Message-ID: <20130416145953.GA8184@zod.gha.chartermi.net>
References: <20130416162047.2f9b83fe.skraw@ithnet.com>
 <CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvykqMUHrmdZnzPXW7i3-ubcF6jv2fLYF3sYPkCtJDJZuA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 04:55:25PM +0200, richard -rw- weinberger wrote:
>On Tue, Apr 16, 2013 at 4:20 PM, Stephan von Krawczynski
><skraw@ithnet.com> wrote:
>> Hello,
>>
>> can some kind soul please explain how I can get my serial port back under
>> kernel 3.8.X. Earlier kernels showed:
>>
>> Jan 10 13:57:18 mybox kernel: [    0.712829] serial8250: ttyS0 at I/O 0x3f8
>> (irq = 4) is a 16550A
>>
>> But 3.8.4:
>>
>> Mar 26 10:39:14 admin kernel: [    0.603647] serial 00:0a: disabled
>>
>> Only kernel is replaced, no change in distro
>> Is there some kernel boot parameter needed now?
>> I tried 3.4.X and it works, even 3.7.X works...
>
>So, 3.8.3 worked and 3.8.4 introduced a regression?
>If so please confirm.
>
>CC'ing gregkh, just in case...

We had a report of this in Fedora that was fixed with 3.8.7.  An upstream
change had been brought back to the 3.8.x series, and it was subsequently
reverted.  3.8.7 picked up the revert.

josh
