Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3CAQIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 11:08:52 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:54476 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3CAQIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 11:08:51 -0500
MIME-Version: 1.0
In-Reply-To: <web-850647262@zbackend1.aha.ru>
References: <web-850647262@zbackend1.aha.ru>
Date: Fri, 1 Mar 2013 08:08:50 -0800
X-Google-Sender-Auth: aXQHOEDZYsXnTTdTb1MlUHxg06A
Message-ID: <CA+55aFwBVrnJwsSsk0LDiYxBJ97ErSONubpB6cO+B49NWgEWiw@mail.gmail.com>
Subject: Re: Linux 3.8-rc1: compiling problem in perf-event-p6.o
From: Linus Torvalds <torvalds@linux-foundation.org>
To: werner <w.landgraf@ru.ru>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 7:08 AM, werner <w.landgraf@ru.ru> wrote:
> That should be corrected, even if it's a problem of the CC version /
> libries, or not,   compilation can't depend on this, code can't be so
> non-standard that it depends on the compiler version.

The __devinit is removed in current git already. If it still does
something like that, then the compiler is too buggy to be used. It's a
plain static "u64" array, nothing more.

          Linus
