Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaEUAbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:31:41 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:44674 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaEUAbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:31:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140520214846.GO15585@mwanda>
References: <1400621339-7514-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140520214846.GO15585@mwanda>
Date: Wed, 21 May 2014 09:31:39 +0900
Message-ID: <CAHb8M2DYAuxVLaJUY5QWHjaai8eXzrxuFaVWwDzFrxznJud3Bw@mail.gmail.com>
Subject: Re: [PATCH] staging: ozwpan: ozproto.c: Fix for possible null pointer dereference
From: DaeSeok Youn <daeseok.youn@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Rupesh Gujare <rupesh.gujare@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was already sent for this. :-)
https://lkml.org/lkml/2014/5/16/114

Regards,
Daeseok Youn.

2014-05-21 6:48 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, May 20, 2014 at 11:28:59PM +0200, Rickard Strandqvist wrote:
>> There is otherwise a risk of a possible null pointer dereference.
>>
>> Was largely found by using a static code analysis program called cppcheck.
>>
>
> This is the empty string by default, or a module parameter.  I have
> looked at param_set_charp() and I don't think a string module parameter
> can be a NULL pointer.
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
