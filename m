Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaIGBmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 21:42:39 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43097 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaIGBmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 21:42:38 -0400
Message-ID: <540BB7E8.3030907@ahsoftware.de>
Date: Sun, 07 Sep 2014 03:42:00 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: Rob Landley <rob@landley.net>, Rogelio Serrano <rogelio.serrano@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OT: Open letter to the Linux World
References: <20140812202129.GA20344@home.goodmis.org> <yw1xr40l2whi.fsf@unicorn.mansr.com> <20140813082756.GB2923@twins.programming.kicks-ass.net> <20140813090013.GA20581@pd.tnic> <53F242D1.4050506@ahsoftware.de> <CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com> <5408B069.9080708@ahsoftware.de> <CAOS_Y6RAiwY=Zh4g6Ei4UYm3FMybwf+bSo_CwqQhaMsaJh10uw@mail.gmail.com> <540958AD.8030503@ahsoftware.de> <540B6819.9030201@ahsoftware.de> <20140906234405.GA17692@csclub.uwaterloo.ca>
In-Reply-To: <20140906234405.GA17692@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.09.2014 01:44, schrieb Lennart Sorensen:

> So why C++ then if you care about making the code easy to make safe when
> there are clearly even better options.  Why not OCAML or Erlang or one
> of the other much more robust languages that don't contain all the
> dangers of C?

I would choose Prolog. ;)

I don't have to provide an answer because I'm not one of those which 
have gone out to change this critical part of many systems.

My concerns are that C is one of the worst languages for that. I'm not
saying that C++ would be the best solution. But I'm pretty sure it would 
have been a much better solution than C.

That means I haven't spend much time (around zero) to think about what 
an init-replacement has to do and how it would be done best. I'm just 
very concerned about what happens there.

So here are just some thoughts:

- Why do you call OCAML or Erlang more robust? Many problems in other 
languages just aren't well known because they are only used by a few 
people which don't tell you bad things about the language they've 
choosen. ;)

- Can you achieve all goals with just using OCAML or another language? 
My experience is that in almost all of those "very well designed 
languages", you are reaching very often some limits or problems which 
are very ugly to solve, if it's possible at all to solve them.

- How many people do you know which can program (and review) that language?

- How robust are the compilers/interpreters? How are they maintained? 
What happens if you find a bug in the compiler/interpreter?

But, as said above, I don't have to provide a solution because I'm not 
the one who has gone out to change PID 1 into something more complicated. ;)

Regards,

Alexander Holler
