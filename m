Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab3JGXlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:41:10 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:33848 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3JGXlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:41:06 -0400
MIME-Version: 1.0
In-Reply-To: <52533965.3080906@zytor.com>
References: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
	<52533965.3080906@zytor.com>
Date: Mon, 7 Oct 2013 20:41:05 -0300
Message-ID: <CAGG-pUT2FJtnih23rZbA8XQMHq7s9GTZCUSEW7yPg3+kOM4VLQ@mail.gmail.com>
Subject: Re: [PATCH] x86: mkpiggy.c: fix resource leakage
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Yes, Really doesn't have leakage, I explained it. The changes are just
to cleanup the code following a secure pattern.

Geyslan Gregório Bem
hackingbits.com


2013/10/7 H. Peter Anvin <hpa@zytor.com>:
> On 10/07/2013 03:16 PM, Geyslan G. Bem wrote:
>> Even though the resource is released when the application is closed or
>> when returned from main function, modified to make it in accordance.
>> Now FILE pointer is always verified.
>
> By the way, the subject is misleading - there is no resource leakage
> since the program is terminated anyway.
>
>         -hpa
>
>
