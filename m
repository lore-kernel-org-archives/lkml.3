Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3GGJWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 05:22:44 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36805 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3GGJWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 05:22:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130706191237.GA2468@shutemov.name>
References: <1372945246-21605-1-git-send-email-artagnon@gmail.com>
 <1372945246-21605-3-git-send-email-artagnon@gmail.com> <878v1lzqe3.fsf@sejong.aot.lge.com>
 <20130706191237.GA2468@shutemov.name>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Sun, 7 Jul 2013 14:52:01 +0530
Message-ID: <CALkWK0mzzYsK04gvnQXbkJ0Q8PAeDur3zO8f5KVDDjQ7dhHUjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: squelch warnings from perl.h to compile-pass
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> On Fri, Jul 05, 2013 at 11:34:12AM +0900, Namhyung Kim wrote:
>> On Thu,  4 Jul 2013 19:10:46 +0530, Ramkumar Ramachandra wrote:
>> > Currently, a simple
>> >
>> >   $ make
>> >
>> > errors out because we compile with -Werror by default, turning all
>> > warnings into errors.  Although no warnings are emitted by our code
>> > itself, two kinds of warnings are emitted by perl.h (perl 5.18.0):
>> >
>> >   -Wundef and -Wswitch-default
>>
>> IIRC there's a floating patch for this, but I cannot find it now.
>
> This one: https://lkml.org/lkml/2013/6/24/66 ?

Yeah, I think this is more sensible than my approach.
