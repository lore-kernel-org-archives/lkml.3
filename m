Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaG0Vas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 17:30:48 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43090 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaG0Var (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 17:30:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140727184434.GA29496@kroah.com>
References: <1406416225-8795-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20140727184434.GA29496@kroah.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Sun, 27 Jul 2014 23:30:26 +0200
Message-ID: <CAFo99gYMycj8dck4e3PxKKPsS-ne8i3Yqtv=pUNg_CqGkHQhLg@mail.gmail.com>
Subject: Re: [PATCH] staging: ced1401: userspace: use1401.c: Cleaning up
 missing null-terminate in conjunction with strncpy
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Monam Agarwal <monamagarwal123@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-27 20:44 GMT+02:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Jul 27, 2014 at 01:10:25AM +0200, Rickard Strandqvist wrote:
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>> And replacing strncat with strlcat because of incorrect use.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/ced1401/userspace/use1401.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> This file is no longer in my tree :(


Hi

No, it does not exist in Linux-next anymore...  I must keep better
track of linux-next :-/


Kind regards
Rickard Strandqvist
