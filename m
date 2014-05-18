Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaERPty (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:49:54 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34675 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaERPtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:49:52 -0400
MIME-Version: 1.0
In-Reply-To: <20140517185615.GB15585@mwanda>
References: <1400190833-27882-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140515224327.GA16255@mwanda>
	<CAFo99gYEf6GrAjuWNc5+DEEuBV82eejRuy7QtiJuLD+sRccLRA@mail.gmail.com>
	<20140517185615.GB15585@mwanda>
Date: Sun, 18 May 2014 17:49:52 +0200
Message-ID: <CAFo99gbnN8j8WgY3O1eDgkpkmJU11X8-9cCU_0_s7TRN8wNW+Q@mail.gmail.com>
Subject: Re: [PATCH] Fix for possible null pointer dereference in node.c
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masood Mehmood <ody.guru@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

When I run cppcheck find the about 5,000 errors, of these, I selected
the 100 most serious and has made patches. But my ability to immerse
myself in each failure has been limited unfortunately.

Okay, I send it through the scripts instead.


Best regards
Rickard Strandqvist


2014-05-17 20:56 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sat, May 17, 2014 at 03:21:56PM +0200, Rickard Strandqvist wrote:
>> Okay, everyone agrees with Dan..?
>>
>
> You can audit it yourself, there are only 4 callers.  The
> node_allocate() is total garbage so the second delete_node() is a bit
> complicated to read but it's not that hard.
>
>> I have made a new patch, which does not check if hnode is NULL.
>
> Send it inline so we can use our normal scripts.
>
> regards,
> dan carpenter
>
