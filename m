Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab3BYPE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:04:28 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47634 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab3BYPEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:04:21 -0500
MIME-Version: 1.0
In-Reply-To: <1361642349.6787.12.camel@mattotaupa>
References: <1361619112-7481-1-git-send-email-mc74hc00@gmail.com>
	<1361642349.6787.12.camel@mattotaupa>
Date: Tue, 26 Feb 2013 00:04:18 +0900
Message-ID: <CAHh0gOi=3VtYBQ7do6xcRwhkCFTair=XO8+cd0LmQYiGBYNN0Q@mail.gmail.com>
Subject: Re: [PATCH] sp5100_tco: Remove code that may cause a boot failure
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: linux-watchdog@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Nieder <jrnieder@gmail.com>, linux-kernel@vger.kernel.org,
        Florian Mickler <florian@mickler.org>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Joseph Salisbury <josephtsalisbury@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Thank you for always helping!

2013/2/24 Paul Menzel <paulepanter@users.sourceforge.net>:
> Dear Takahisa,
>

> all SB700 boards or just a specific one?

The problem is found only on the ASUSTeK M3A78-CM at the moment. The
problem prevents OS from booting, and, It's critical. Therefor, I
thought that It is safe to delete the reprogramming code of chipset
until a reason is found.

https://lkml.org/lkml/2013/2/23/10


> Is that problem there since the first implementation or just with your
> second patch? (I do not have the commit hashes and summaries ready.)

The problem occurred in both the first implementation and my second patch.
Please refer to following LKML thread.

https://lkml.org/lkml/2013/2/14/271


> The Bugzilla entry is not really related to this report. Please make
> clear that this is the report the original patch wanted to fix. As
> nobody closed it yet, it does not need to be reopened.

Sorry, you just said it. I will replace the URL of Bugzilla with URL
of LKML thread, and resend the
patch to LKML.


> To address Greg’s comment, your patch first has to land in Linus’ master
> branch and only then it can be backported/applied to the stable series.
> This will be done automatically if you just add

It's my mistake that I add stable@vgar.kernel.org to CC. This patch
isn't able to apply Linus master branch, because this patch is
dependent on second patch which isn't merged into Linus' master
branch.


Regards,
Takahisa
