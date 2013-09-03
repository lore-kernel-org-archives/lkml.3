Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664Ab3ICJ1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 05:27:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313Ab3ICJ1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 05:27:21 -0400
Date: Tue, 3 Sep 2013 11:27:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chen Gang <gang.chen@asianux.com>
Cc: Li Zefan <lizefan@huawei.com>, Joe Perches <joe@perches.com>,
        Jens Axboe <axboe@kernel.dk>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] block/ioctl.c: let code match 'kernel code
 style'
In-Reply-To: <5225A685.5040507@asianux.com>
Message-ID: <alpine.LNX.2.00.1309031126250.20551@pobox.suse.cz>
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com>
 <52208DFD.20105@roeck-us.net> <52240566.3040201@asianux.com> <52259DDE.6070401@asianux.com> <5225A3F8.5070008@huawei.com> <5225A685.5040507@asianux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Chen Gang wrote:

> Do you mean "coding style", not "colding style"? (or it is my
> misunderstanding?).
> 
> 
> > You're not going to run checkpatch.pl on the whole kernel tree and fix
> > all the complaints, are you?
> > 
> 
> I am not going to, it seems that may be the 'job' of Joe and
> trivial@kernel.org?

FWIW, I am not generally accepting pure code reformatting patches.

-- 
Jiri Kosina
SUSE Labs
