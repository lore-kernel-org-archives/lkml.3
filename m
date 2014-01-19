Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbaASP3M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 10:29:12 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:64333 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaASP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 10:29:09 -0500
MIME-Version: 1.0
In-Reply-To: <20140119144725.GE27187@pd.tnic>
References: <1390079163.25980.2.camel@x41>
	<CACPM=kVdNm+ZiZsfr1PTVzOBJi+ybOQVs5X=BycEeZxJLVEq_g@mail.gmail.com>
	<20140118221212.GB15543@pd.tnic>
	<CACPM=kUtm0i5qRWGs9yKBMDZ0fFEQ5-US6wdfa+bjh6ZB2ZhOQ@mail.gmail.com>
	<20140118223308.GH15466@pd.tnic>
	<CACPM=kVDpAFSWb3v8zS0+JE2U5C6pSNvqvL+aQ-npLtU05JGrA@mail.gmail.com>
	<20140118234611.GJ15466@pd.tnic>
	<CACPM=kXvNHA42yP9oBJX1OoH_c+v9mDX4UaYx9huKsk8FJZHwA@mail.gmail.com>
	<20140119122058.GB27187@pd.tnic>
	<CACPM=kUf+yR1HsPMJy+rf=p5uLWEw0RJSxgye0dPGe+-DeBURA@mail.gmail.com>
	<20140119144725.GE27187@pd.tnic>
Date: Sun, 19 Jan 2014 16:29:07 +0100
X-Google-Sender-Auth: e1b0ODwrrwzvCFjZLYduVYW8tBA
Message-ID: <CACPM=kV=CvVmbnheL5NKRrJFzwuKJ4_qqizcnxWfr1pwzngRaw@mail.gmail.com>
Subject: Re: [PATCH] Adding hyperv.h to uapi headers
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Bolle <pebolle@tiscali.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/19 Borislav Petkov <bp@alien8.de>:
> On Sun, Jan 19, 2014 at 03:37:24PM +0100, Bjarke Istrup Pedersen wrote:
>> > Oh, and some build infra so that they can be buildable from within the
>> > kernel tree.
>>
>> Indeed, but first lets get it building :-)
>
> Oh, I didn't mean you with that, rather the other readers on this
> thread. Unless you really want to do it - which is then cool. :-)

I have sent a patch adding the makefile for the hyperv tools :-)
It does not include any of there changes, so it does not replace the v2 patch.

/Bjarke

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
