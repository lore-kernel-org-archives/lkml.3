Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaGaJKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:10:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:35427 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932265AbaGaJKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:10:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140731082051.GL4856@mwanda>
References: <1406756021-3578-1-git-send-email-fernando.apesteguia@gmail.com>
	<20140731082051.GL4856@mwanda>
Date: Thu, 31 Jul 2014 11:10:33 +0200
Message-ID: <CAGwOe2aYVBbFjAAKtSojwSXF2p=d8AHgmWyHAofxmWQRht10ww@mail.gmail.com>
Subject: Re: [PATCH] Staging: rtl8192u: Staticfy debug method.
From: =?UTF-8?Q?Fernando_Apestegu=C3=ADa?= 
	<fernando.apesteguia@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El 31/07/2014 10:21, "Dan Carpenter" <dan.carpenter@oracle.com> escribió:
>
> You need to compile these things before sending them...
>
> This adds a GCC warning about uncalled functions.

Sorry, but I did compile it with

make C=1 M=drivers/staging

But for the function to be called, DEBUG_EPROM must be defined and I
had it defined. That's why I overlooked the warning.

Apologies.
>
> regards,
> dan carpenter
>
