Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbaGCSRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 14:17:18 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40461 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaGCSRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 14:17:16 -0400
MIME-Version: 1.0
In-Reply-To: <53B59DC2.20809@twiddle.net>
References: <CAPDOMVj3sJSfgA7hBv9Tx0oz5ZX73robsTZygVJfU_QZ9A65dg@mail.gmail.com>
	<53B59DC2.20809@twiddle.net>
Date: Thu, 3 Jul 2014 14:17:15 -0400
Message-ID: <CAPDOMVh_AjUwGt5woz7sipFw=fVusbzkoAn1h+eRavN1PbFwFg@mail.gmail.com>
Subject: Re: FIX ME message in osf_sys.c
From: Nick Krause <xerofoify@gmail.com>
To: Richard Henderson <rth@twiddle.net>
Cc: ink@jurassic.park.msu.ru, Matt Turner <mattst88@gmail.com>,
        linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In that case I will sent a patch removing this FIXME line.
Cheers Nick

On Thu, Jul 3, 2014 at 2:15 PM, Richard Henderson <rth@twiddle.net> wrote:
> On 07/03/2014 10:21 AM, Nick Krause wrote:
>> There seems to be a Fix Me message on line 892 due to info.si_addr = NULL.
>> I am wondering what value I should declare this variable to instead of Null.
>> Cheers Nick
>>
>
> The closest thing to compatibility with SIGFPE raised through normal arithmetic
> would be the address of the instruction after the callsys that lead to this
> system call.  Except that's not available without complicating the call to
> osf_setsysinfo, and it doesn't seem worth it.
>
>
> r~
