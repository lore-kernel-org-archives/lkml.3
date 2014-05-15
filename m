Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaEOWOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 18:14:33 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61766 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaEOWOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 18:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140515220808.GA13306@kroah.com>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140515220808.GA13306@kroah.com>
Date: Fri, 16 May 2014 00:14:31 +0200
Message-ID: <CAFo99gbSLRaV+f=53b+ph+P=TH1faDZ0PATENVDtv_v+6mA+Xw@mail.gmail.com>
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Masood Mehmood <ody.guru@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all, and Greg!

Good idea!
I will do it in all the other mail.


Best regards
Rickard Strandqvist


2014-05-16 0:08 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Thu, May 15, 2014 at 11:53:53PM +0200, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/tidspbridge/rmgr/node.c |    4 ++--
>>  1 fil ändrad, 2 tillägg(+), 2 borttagningar(-)
>
> Please work a bit on your Subject lines to make it easier to figure out
> where the patches belong.
>
> For this one, it should be:
>         Subject: staging: tidspridge: fix for possible null pointer dereference in node.c
> or:
>         Subject: staging: tidspridge: node.c: fix for possible null pointer dereference
>
> That way people can figure out _what_ node.c file you are referring to
> and to see if they care about it or not :)
>
> thanks,
>
> greg k-h
