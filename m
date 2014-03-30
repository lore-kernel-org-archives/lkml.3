Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbaC3Iof (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 04:44:35 -0400
Received: from mail-ie0-f196.google.com ([209.85.223.196]:49822 "EHLO
	mail-ie0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbaC3Iod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 04:44:33 -0400
MIME-Version: 1.0
In-Reply-To: <87r45lqcm7.fsf@igel.home>
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
Date: Sun, 30 Mar 2014 10:44:33 +0200
Message-ID: <CAOte+=YX5z9wri5Cj=JxHF2JjQroKYKAXurh=JRfjQH5eU_hyQ@mail.gmail.com>
Subject: Re: Support for netconsole as default tty/console?
From: Struan Bartlett <struan.bartlett@gmail.com>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 March 2014 15:54, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Struan Bartlett <struan.bartlett@gmail.com> writes:
>
>> Adding console=netconsole to the command line does not appear to have
>> the desired effect. I am not sure if this is because netconsole,
>> unlike the serial console, does not provide a tty. Can anyone advise
>> if this understanding is correct? If so, is there an independent
>> solution to this problem?
>
> It should not be hard to add a tty driver to netconsole, there are many
> examples to borrow from.

Thank you. I've begun investigating the sources in drivers/tty. Am I
correct in thinking that this only needs a tty driver, and not also a
serial driver?
