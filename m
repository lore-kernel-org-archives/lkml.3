Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbaLZV0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 16:26:06 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36399 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaLZV0E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 16:26:04 -0500
MIME-Version: 1.0
In-Reply-To: <1419618798-9275-1-git-send-email-oscar.forner.martinez@gmail.com>
References: <1419618798-9275-1-git-send-email-oscar.forner.martinez@gmail.com>
Date: Fri, 26 Dec 2014 22:26:03 +0100
Message-ID: <CACna6rx4CPwzH0K9R3AtdXN8GbRcu-6VqXue7fFPh770WhR_aw@mail.gmail.com>
Subject: Re: [PATCH v2] bcma: Fix three coding style issues, more than 80
 characters per line
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Oscar Forner Martinez <oscar.forner.martinez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 December 2014 at 19:33, Oscar Forner Martinez
<oscar.forner.martinez@gmail.com> wrote:
> -                       /* 4706 CC and PMU watchdogs are clocked at 1/4 of ALP clock */
> +                       /* 4706 CC and PMU watchdogs are clocked
> +                        * at 1/4 of ALP clock
> +                        */

Your editor seems to be treating tabs incorrectly. Like more than 8
chars. After your patch "clocked" ends after  64 chars. You should try
to use up to 80 chars.


> -               bcma_err(cc->core->bus, "serial not supported on this device ccrev: 0x%x\n", ccrev);
> +               bcma_err(cc->core->bus,
> +                        "serial not supported on this device ccrev: 0x%x\n",
> +                        ccrev);

I think you ignored my comment to V1, see it again please ;) It was
about putting pointer and string in one line.

-- 
Rafał
