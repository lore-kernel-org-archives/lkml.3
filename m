Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaIEGbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:31:49 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:39446 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEGbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:31:48 -0400
Message-ID: <540958AD.8030503@ahsoftware.de>
Date: Fri, 05 Sep 2014 08:31:09 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Rogelio Serrano <rogelio.serrano@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Christopher Barry <christopher.r.barry@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OT: Open letter to the Linux World
References: <20140812153812.2923046a@monolith.infinux.org>	<20140812202129.GA20344@home.goodmis.org>	<yw1xr40l2whi.fsf@unicorn.mansr.com>	<20140813082756.GB2923@twins.programming.kicks-ass.net>	<20140813090013.GA20581@pd.tnic>	<53F242D1.4050506@ahsoftware.de>	<CANszf4jauBAhaTogvSprhhspKywXSu_8xkWh+ETsWMMUDKo0=g@mail.gmail.com>	<5408B069.9080708@ahsoftware.de> <CAOS_Y6RAiwY=Zh4g6Ei4UYm3FMybwf+bSo_CwqQhaMsaJh10uw@mail.gmail.com>
In-Reply-To: <CAOS_Y6RAiwY=Zh4g6Ei4UYm3FMybwf+bSo_CwqQhaMsaJh10uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.09.2014 21:18, schrieb Rob Landley:

> What's actually wrong with C++ at a language design level.
>
> Short version:

OMG.

It's better than C. In almost every aspect. Stop. Nothing else. Of
course, if you want to write something like systemd in Python, Perl,
Pascal, Modula or Erlang, feel free to so. And if you want more security
bugs, feel free to still use C for string handling instead of
std::string, Or still write your sorted list for every structure (or 
just don't and go the slow way, because you don't find the time to do it 
right in C). And ...

You don't have to understand how templates do work to use e.g.
std::string. Other people do hard stuff for you. So don't panic.

Alexander Holler
