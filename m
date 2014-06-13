Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaFMFQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:16:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43545 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaFMFQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:16:11 -0400
Message-ID: <539A890A.5090206@zytor.com>
Date: Thu, 12 Jun 2014 22:15:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Subject: Re: vdso feature requests from the Go people
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
In-Reply-To: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
> 
> If we were to implement both, maybe we'd actually want to provide
> something like:
> 
> struct vdso_entry {
>   unsigned long vdso_entry_struct_size;  /* so we can add fields later on */
>   void *func;
>   unsigned int max_stack;  /* zero if not known */
> };
> 

How different is this really from the .dynsym table -- other than that
you have to find the latter via the dynamic segment?

The hash part is just to speed up lookup...

	-hpa


