Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336Ab3AOU3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:29:19 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:61464 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3AOU3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:29:15 -0500
Date: Tue, 15 Jan 2013 21:29:04 +0100
From: =?ISO-8859-2?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] lpc_ich: fix gpio base and control offsets
Message-ID: <20130115212904.6c8e96ad@palee-debian>
In-Reply-To: <a858277c-6164-4d43-abee-a3d34ad8b04c@zimbra>
References: <fe420c78-bf1b-40f0-b3f0-09ea26986de2@zimbra>
	<a858277c-6164-4d43-abee-a3d34ad8b04c@zimbra>
X-Mailer: Claws Mail 3.9.0cvs55 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tue, 15 Jan 2013 13:12:15 -0600 (CST) -n
Aaron Sierra <asierra@xes-inc.com> wrote:

>  #define ACPIBASE_GCS_END	0x3414
>  
>  #define GPIOBASE		0x48
> +#define GPIOBASE_ICH5		0x58
>  #define GPIOCTRL		0x4C
> +#define GPIOCTRL_ICH5		0x58
>  
>  #define RCBABASE		0xf0

Aaron,
A like this corrected patch and a little fix that GPIOCTRL_ICH5 is 0x5C
Is this correct? Thanks!

--
