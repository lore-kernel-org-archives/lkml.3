Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3KINPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 08:15:08 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35283 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3KINPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 08:15:04 -0500
MIME-Version: 1.0
In-Reply-To: <527E30BD.3030604@linux.com>
References: <1384003422-24683-1-git-send-email-b.covolato@gmail.com>
	<527E30BD.3030604@linux.com>
Date: Sat, 9 Nov 2013 14:15:02 +0100
Message-ID: <CAP_kqcjdZGdL6rq+vnhf3qAWhMGoBhrR8A4bcJh=wATQjGqgyQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: Add possibility to compile android
 drivers as modules
From: Baptiste Covolato <b.covolato@gmail.com>
To: levex@linux.com
Cc: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review.

Should I repost this patch with correct git commit message here or in
another mail ?

Regards,

--
Baptiste Covolato


2013/11/9 Levente Kurusa <levex@linux.com>:
> 2013-11-09 14:23 keltezéssel, Baptiste Covolato írta:
>> Compilation of Android staging drivers as drivers is now possible.
>
> 'drivers as drivers'? :-)
>
> Also, this commit message says nothing about what the patch does.
> Something like this would be more appropriate:
> Edit Android Kconfig files to allow building the drivers as modules.
>
>
>
> --
> Regards,
> Levente Kurusa
