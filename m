Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122AbaFCRXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:23:07 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:52043 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932762AbaFCRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:23:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
	<538D2261.70406@huawei.com>
	<20140603012211.GE19855@htj.dyndns.org>
	<CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com>
Date: Tue, 3 Jun 2014 10:23:03 -0700
X-Google-Sender-Auth: zFHg7UVA8fc40Wz6y2xBmDV0bTI
Message-ID: <CA+55aFxfEsOZreYBCrDTfgaSf0441zXf4uSmzsYU-JXHBRkzJg@mail.gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2014 at 6:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Of course, Greg could just send it to me for my next branch (since the
> merge window for 3.16 is already open) and tell me that it's also
> stable material for 3.15. At _that_ point I'll happily cherry-pick it
> into master...

Ok, so that happened.

Tejun, just to be anal, can you please test and verify current -git
(preferably both 'master' and 'next') with your app that cared about
the f_type information for statfs()..

             Linus
