Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaFFSkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 14:40:11 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63221 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaFFSkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 14:40:08 -0400
From: Andy Lutomirski <luto@amacapital.net>
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <53920B05.9010602@mit.edu>
Date: Fri, 06 Jun 2014 11:40:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?IkjDoW4gU2jEm24gKOayiOa2tSki?= <shenhan@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: "." in vmlinux.lds.S
References: <CACkGtriM1jwP9OSED21mNrKWPubeJp9YjL-8uetLqhjqfoH=Lg@mail.gmail.com> <CACkGtrincr-oEu5Aq2EpYmbJDVSzuzwLguOaUvRY4uBqz=5-6A@mail.gmail.com>
In-Reply-To: <CACkGtrincr-oEu5Aq2EpYmbJDVSzuzwLguOaUvRY4uBqz=5-6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 10:08 AM, Hán Shěn (沈涵) wrote:
> A gentle ping?
> 
> On Tue, Jun 3, 2014 at 2:46 PM, Hán Shěn (沈涵) <shenhan@google.com> wrote:
>> Hi we are trying to boot up a x86_64 chrome book using binutils 2.24 and
>> kernel 3.8, but failed.
>>
>> After some triage work, we found that a 2-year-old binutil CL changed the
>> interpretation of "." in linker script （short story: absolute -> relative,
>> long story: https://sourceware.org/ml/binutils/2012-06/msg00155.html).
>>
>> After some further work, we are able to boot the kernel with a kernel patch
>> pasted at EOM. I am curious, why the upstream kernel is never hit by this
>> behavior? We enabled "CONFIG_DEBUG_RODATA", so we were hit, is this some
>> macro not usually turned on?

What does a section-relative symbol do?

--Andy
