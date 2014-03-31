Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbaCaCFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 22:05:55 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:60185 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaCaCFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 22:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140330171703.GE22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-9-git-send-email-jovi.zhangwei@gmail.com>
	<20140330024701.GA22728@two.firstfloor.org>
	<CAGdX0WG6Nid66iuRWqLbfmH89XacEXuUNYCNjnB7j=HYiyCKBw@mail.gmail.com>
	<20140330171703.GE22728@two.firstfloor.org>
Date: Mon, 31 Mar 2014 10:05:53 +0800
Message-ID: <CAGdX0WERQixTQc7NcvqMs6E=ifDOFXgaavvuK7tocs+a-=EVnA@mail.gmail.com>
Subject: Re: [PATCH v2 08/29] ktap: add bytecode reader(kernel/trace/ktap/kp_bcread.[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 1:17 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> That's designed for portability initially, it means we can just run bytecode
>> without compile script file everywhere, especially when compilation  is
>> a heavily task for some embedded platform, even though ktap compilation
>> is extremely fast.
>>
>> I doubt maybe there will have this bytecode portability requirement in future?
>
> Portability should be on the source level.
>
>
That's fine, I will add one endianness flag in bytecode header, kernel
will reject
loading if find endianness doesn't match.

Thanks.

Jovi
