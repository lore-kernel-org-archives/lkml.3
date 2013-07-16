Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3GPFvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:51:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:56760 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3GPFvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <87zjtnyuai.fsf@rustcorp.com.au>
References: <CAK7N6vokZpFJkYapajhqTYWvPVWr6ELz+5Nq9yvf0J5VAx=JBA@mail.gmail.com>
	<87zjtnyuai.fsf@rustcorp.com.au>
Date: Tue, 16 Jul 2013 11:21:27 +0530
Message-ID: <CAK7N6vrTX22uaox9mg4Uqkd4D1xNOvAyFQirTKNz9Ey3WOQu3Q@mail.gmail.com>
Subject: Re: Question:Bsearch replace the search_extable implementations
From: anish singh <anish198519851985@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Tim Abbott <tabbott@ksplice.com>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:29 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> anish singh <anish198519851985@gmail.com> writes:
>> Hello Rusty,
>>
>> Right now I see so many places in the kernel
>> where we open code binary search implementations
>> such as search_extable implementations.
>>
>> http://lxr.free-electrons.com/ident?a=powerpc;i=search_extable
>>
>> Would it be ok to replace this with bsearch lib code?
>>
>> I am not trying to fix any problem nor I see
>> any problem in current implementations but
>> if we can replace the large amount of code
>> would it not be a good reason to send a patch
>> for this?
>
> It should be fine, yes.
great.Will be sending patch for this soon.
>
> Thanks!
> Rusty.
