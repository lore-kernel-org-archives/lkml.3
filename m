Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650AbaB0UWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:22:48 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:38410 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaB0UWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:22:46 -0500
MIME-Version: 1.0
In-Reply-To: <530EBFC7.9030309@zytor.com>
References: <1393462087.24588.50.camel@joe-AO722>
	<530E8C2E.7080307@zytor.com>
	<1393466619.24588.65.camel@joe-AO722>
	<20140227022857.GC23659@thin>
	<1393469594.24588.71.camel@joe-AO722>
	<20140227025845.GA25145@thin>
	<530EB103.5070406@zytor.com>
	<1393472326.24588.82.camel@joe-AO722>
	<20140227040050.GA8449@nicira.com>
	<530EBCED.9020705@zytor.com>
	<20140227042636.GA9592@nicira.com>
	<530EBFC7.9030309@zytor.com>
Date: Thu, 27 Feb 2014 12:22:45 -0800
X-Google-Sender-Auth: iUfGy6i-lwxuhuLBy-meaUsDY8M
Message-ID: <CANeU7Q=RNXR00bQcPzJYTOcZmRSn3U31ZcadPTHu6Y_Uk0UnYw@mail.gmail.com>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
From: Christopher Li <sparse@chrisli.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ben Pfaff <blp@nicira.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 8:32 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Quite frankly, this is silly in my opinion, *and* it is not guaranteed
> by C either (read about "trap representations").
>>
> Anything that moves data around in a generic fashion.  It can be as
> simple as:
>
>         memcpy(foo, bar, sizeof *foo);

OK. I get it nobody wants a sizeof(_Bool) warning.

I am going to apply this patch.

Should we change the default to off then?

Thanks.

Chris
