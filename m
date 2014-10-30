Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759745AbaJ3Mrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:47:41 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36349 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759539AbaJ3Mrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:47:39 -0400
MIME-Version: 1.0
In-Reply-To: <87vbn1222e.fsf@ptsecurity.com>
References: <87vbn1222e.fsf@ptsecurity.com>
Date: Thu, 30 Oct 2014 13:47:36 +0100
Message-ID: <CAH6sp9PWt9ZyctdqRF5LMQdm1K8Ph-KJ4ODNv69y6L2kbYrMHg@mail.gmail.com>
Subject: Re: Fun with looping binds over proc
From: Frans Klaver <fransklaver@gmail.com>
To: Serge Kosyrev <skosyrev@ptsecurity.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Oct 30, 2014 at 1:07 PM, Serge Kosyrev <skosyrev@ptsecurity.com> wrote:
>
> [deepfire@andromedae:~/repro-kernel-loop-mount]$ uname -a
> Linux andromedae 3.14.22 #1-NixOS SMP Thu Jan 1 00:00:01 UTC 1970 x86_64 GNU/Linux
>

<snip>

> [deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh
>
> real    0m3.186s
> user    0m0.010s
> sys     0m3.023s
>
> [deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh
>
> real    0m6.732s
> user    0m0.013s
> sys     0m6.032s
>
> [deepfire@andromedae:~/repro-kernel-loop-mount]$ time sudo ./repro.sh
>
> real    0m14.541s
> user    0m0.008s
> sys     0m12.115s
> Please read the FAQ at  http://www.tux.org/lkml/

I don't seem to be able to reproduce this on 3.17.0-rc3. Tried the
latest rc release?

Frans
