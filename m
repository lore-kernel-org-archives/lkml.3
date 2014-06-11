Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaFKUE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:04:57 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39516 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKUE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:04:56 -0400
MIME-Version: 1.0
X-Originating-IP: [5.35.52.78]
In-Reply-To: <20140611173851.GA5556@MacBook-Pro.local>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com>
	<20140611173851.GA5556@MacBook-Pro.local>
Date: Thu, 12 Jun 2014 00:04:55 +0400
Message-ID: <CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com>
Subject: Re: kmemleak: Unable to handle kernel paging request
From: Denis Kirjanov <kda@linux-powerpc.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Wed, Jun 11, 2014 at 04:13:07PM +0400, Denis Kirjanov wrote:
>> I got a trace while running 3.15.0-08556-gdfb9454:
>>
>> [  104.534026] Unable to handle kernel paging request for data at
>> address 0xc00000007f000000
>
> Were there any kmemleak messages prior to this, like "kmemleak
> disabled"? There could be a race when kmemleak is disabled because of
> some fatal (for kmemleak) error while the scanning is taking place
> (which needs some more thinking to fix properly).

No. I checked for the similar problem and didn't find anything relevant.
I'll try to bisect it.

> Thanks.
>
> --
> Catalin
>
