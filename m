Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3KVWsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:48:13 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:58696 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab3KVWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:48:10 -0500
MIME-Version: 1.0
In-Reply-To: <1385160319.17856.35.camel@joe-AO722>
References: <1385158664-12923-1-git-send-email-ufimtseva@gmail.com>
	<1385160319.17856.35.camel@joe-AO722>
Date: Fri, 22 Nov 2013 17:48:09 -0500
Message-ID: <CAEr7rXhjG0aGF48CkL77a=BQZpwfTzShq88PSQ6gDcaFobeRcg@mail.gmail.com>
Subject: Re: [PATCH v2] checkpatch.pl: Check for functions without a real prototype
From: Elena Ufimtseva <ufimtseva@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: apw <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 5:45 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-11-22 at 17:17 -0500, Elena Ufimtseva wrote:
>> Based on Richard Weinberger patch https://lkml.org/lkml/2012/3/16/510
>> Functions like this one are evil:
>>
>> void foo()
>> {
>>       ...
>> }
> []
>> - added white space in regular expression between (), based
>> on comments from Joe Perches.
>
> Thanks Elena, but this is already applied in -next.
>
>
No problem, thanks Joe )

-- 
Elena
