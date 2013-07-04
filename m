Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab3GDJEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 05:04:05 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51082 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab3GDJED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 05:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130702200147.GC9359@redhat.com>
References: <1372696755-17427-1-git-send-email-dvlasenk@redhat.com> <20130702200147.GC9359@redhat.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 4 Jul 2013 11:03:41 +0200
Message-ID: <CAK1hOcNxG7qW73Q2cr56XfFG-+60HS-M-TrdwniVRtag8YY+Cg@mail.gmail.com>
Subject: Re: [PATCH] Define WTERMSIG{,_MASK} and WCOREDUMP and use where appropriate
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 10:01 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 07/01, Denys Vlasenko wrote:
>>
>> Grepping for numeric constants is inconvenient.
>
> Personally I agree very much, and I like the intent.
>
>> +#define WTERMSIG_MASK     0x7f
>> +#define WTERMSIG(status)  ((status) & WTERMSIG_MASK)
>> +#define WCOREDUMP(status) ((status) & 0x80)
>
> But I am not sure we need WTERMSIG/WCOREDUMP helpers, although
> I won't really argue.

Are you saying that you prefer just mask constants,
do not want macros?
