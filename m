Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab3DYIZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 04:25:17 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:48081 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3DYIZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 04:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <1366875462-7864-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1366875462-7864-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Thu, 25 Apr 2013 10:25:11 +0200
Message-ID: <CAFLxGvxjdYDP4ts9-PNwPWJRi+eCu3vtM+Stz2TkvTXVU7FTXA@mail.gmail.com>
Subject: Re: [PATCH] uio/aec: specify correct license in MODULE_LICENSE
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 9:37 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> The file header declares the code to be covered by GPL v2 only, so use
> explicit v2 for MODULE_LICENSE, too.

Doesn't this apply to almost any driver?
I don't understand why you explicitly "fix" this one.

--
Thanks,
//richard
