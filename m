Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbaANVnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:43:07 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62600 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaANVnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:43:05 -0500
MIME-Version: 1.0
In-Reply-To: <1389734895-2760-1-git-send-email-michaelflowersky@geekingspree.com>
References: <1389734895-2760-1-git-send-email-michaelflowersky@geekingspree.com>
Date: Tue, 14 Jan 2014 22:43:04 +0100
X-Google-Sender-Auth: xrszpqA7OutlOSGWabQKLnManrw
Message-ID: <CAAsK9AG0J_+f+DPZ-j9uYJ9gPLkxG8ZGa20Poa2rLdUvb7-F_w@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: fix parentheses coding style issue in alarm-dev.c
From: Levente Kurusa <levex@linux.com>
To: =?ISO-8859-2?Q?Micha=B3_Kwiatkowski?= 
	<michaelflowersky@geekingspree.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>, dan.carpenter@oracle.com,
        Cruz Bishop <cruzjbishop@gmail.com>, devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014/1/14 Micha³ Kwiatkowski <michaelflowersky@geekingspree.com>:
> From: Michal Kwiatkowski <michaelflowersky@geekingspree.com>
>
> This is a patch to the alarm-dev.c file that removes parentheses which
> should not appear in return statement. This error was found by the
> checkpatch.pl tool.
>
> Signed-off-by: Micha³ Kwiatkowski <michaelflowersky@geekingspree.com>
> --

This is like the third patch in this two week period that does the
exact same with more or less success, and I recall one getting applied
(I might be wrong). Anyway, this one finally looks good! :-)

--
Regards,
Levente Kurusa
