Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbaLAXGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:06:52 -0500
Received: from mail-oi0-f41.google.com ([209.85.218.41]:55713 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932484AbaLAXGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.11.1412020956001.18636@namei.org>
References: <20141125194319.GA9328@www.outflux.net>
	<alpine.LRH.2.11.1411270022240.22560@namei.org>
	<20141127084614.209450b9@canb.auug.org.au>
	<CAGXu5jJQK39HnyVMmVrerY+wiL+P80JTE8nscDa7Wyyk1hZing@mail.gmail.com>
	<alpine.LRH.2.11.1411281037250.28866@namei.org>
	<CAGXu5jJ3KEidL1KdrXnR39r_Na9WaE=VdbeKPkjRQd1OOAZO3A@mail.gmail.com>
	<alpine.LRH.2.11.1412020956001.18636@namei.org>
Date: Mon, 1 Dec 2014 15:06:48 -0800
X-Google-Sender-Auth: pQTZatUJb23hPiBvLkQAAk2Fx6s
Message-ID: <CAGXu5jJnTskkGdAGTPXHEL8B_x7fc_57bQO16oqK6+KCKn09KQ@mail.gmail.com>
Subject: Re: [PULL] seccomp update (next)
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pranith Kumar <bobby.prani@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2014 at 2:56 PM, James Morris <jmorris@namei.org> wrote:
> On Mon, 1 Dec 2014, Kees Cook wrote:
>
>> On Thu, Nov 27, 2014 at 3:37 PM, James Morris <jmorris@namei.org> wrote:
>> > On Wed, 26 Nov 2014, Kees Cook wrote:
>> >
>> >> > That would be because your tree is based on v3.17 and Kees' is based on
>> >> > v3.18-rc6 ...
>> >>
>> >> James, I can base on whatever you like. I can do v3.17, or even
>> >> against your security-next. It seems everyone uses something
>> >> different. :)
>> >
>> > It's best to track my next branch as your upstream.
>>
>> It'll trigger collisions with what's the x86 -next from luto's
>> changes. Should I just let Stephen sort that out?
>
> Yep.

Hm, it depends on 54ef6df3f3f1353d99c80c437259d317b2cd1cbd, so basing
against security-next would make the tree unbuildable. Perhaps I
should just wait for -rc1 to land first?

-Kees

-- 
Kees Cook
Chrome OS Security
