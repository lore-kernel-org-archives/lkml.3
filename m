Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744Ab3GSR37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 13:29:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45650 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3GSR36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 13:29:58 -0400
Message-ID: <51E97779.3020103@zytor.com>
Date: Fri, 19 Jul 2013 10:29:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [QUERY] lguest64
References: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
In-Reply-To: <CALkWK0n7zedKD4tnxKh-qMuDnMJ5RXjnPJ9EUWT=cCgiokX11A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:06 AM, Ramkumar Ramachandra wrote:
> Hi,
> 
> I tried building lguest to play with it, but was disappointed to find
> this in the Kconfig:
> 
>   depends on X86_32
> 
> Why is this [1]?  What is so hard about supporting 64-bit machines?  I
> found a five-year old tree that claims to do lguest64 [2], but didn't
> investigate further.
> 

Please don't have us deal with another lguest unless there is a use case
for it.  We want to reduce pvops and pvops users, not increase them...

	-hpa


