Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaJNVfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:35:01 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:39752 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaJNVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:34:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140918223909.GO17875@mwanda>
References: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140915082346.GB17875@mwanda> <CAFo99gZUiSB2cgSAAj7EBjZJTs7QxvCDZr6Wms3ud5qQvBWQMw@mail.gmail.com>
 <20140918085105.GB16827@mwanda> <CAFo99gbNPLiEFSmeQOpeNwD=cSkXs79tfu2BJqZfmiX8dEsYWA@mail.gmail.com>
 <20140918223909.GO17875@mwanda>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 14 Oct 2014 23:34:37 +0200
Message-ID: <CAFo99gYFjr_Kdz9_orYdNwJ191h5ikV8SdovQxAdagjSA=2Q4w@mail.gmail.com>
Subject: Re: [PATCH] staging: lustre: lustre: libcfs: debug.c: Cleaning up
 unnecessary use of memset in conjunction with strncpy
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-19 0:39 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Thu, Sep 18, 2014 at 09:57:17PM +0200, Rickard Strandqvist wrote:
>>
>> Should I add this as a patch in lib/string.c or email him first.. What
>> is customary in these situations?
>>
>
> Just write up a normal patch and try to merge it through the normal
> methods.
>
> It's not that controversial to do:
>
>         strncpy(dest, src, n);
>         dest[n] = '\0';
>
> That's what we have been open coding all over the place anyway already.


Hi Dan!

I have tried the function strzcpy that we talk about, but it has not
happened anything:-(

Is there anything else I can do?


Kind regards
Rickard Strandqvist
