Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbaHYNvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:51:48 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:33623 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaHYNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <1408972519.20683.41.camel@joe-AO725>
References: <1408966502-22350-1-git-send-email-gdonald@gmail.com> <1408972519.20683.41.camel@joe-AO725>
From: Greg Donald <gdonald@gmail.com>
Date: Mon, 25 Aug 2014 08:51:25 -0500
Message-ID: <CAO+WgCY8Ugv17WMEe0TEn0ruf9HAF=uNZ12OKjZmehsO6kvZ1Q@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: rtl8821ae: Fix spaces required around
 that '?' errors
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 8:15 AM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2014-08-25 at 06:35 -0500, Greg Donald wrote:
>> Fix checkpatch.pl spaces required around that '?' errors
>
> It'd be better to convert all parts of the
> ternary at the same time.

Wouldn't "at the same time" be in direct conflict with the "only do
one thing per patch" rule?

>                     (force_exec ? "force to" : ""), ((dec_bt_pwr) ? "ON" : "OFF")));
>
> etc...
>
> A subsequent change might be to remove the unnecessary
> parentheses like:
>
>                     force_exec ? "force to" : "", dec_bt_pwr ? "ON" : "OFF");

I understand.  It's very likely I'll submit such a patch in the future.

I'm currently attempting to keep my cleanups to a single error/warning
type so I get as much done as possible per patch while also keeping
the patch easy to review.  Is this wrong?


-- 
Greg Donald
