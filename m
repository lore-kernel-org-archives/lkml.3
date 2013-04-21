Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3DUFxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 01:53:15 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:38778 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3DUFxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 01:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130419213152.GD11866@zurbaran>
References: <1366304318-29620-1-git-send-email-andrew.smirnov@gmail.com>
	<20130419213152.GD11866@zurbaran>
Date: Sat, 20 Apr 2013 22:53:11 -0700
Message-ID: <CAHQ1cqGnDvO+wkfdO-o-4JSBgT=0TEww01NM1+o7g=1Hy0QNxw@mail.gmail.com>
Subject: Re: [PATCH v9 00/12] Driver for Si476x series of chips
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I applied all the MFD patches from this patchset (All 4 first ones), plus a
> follow up one for fixing the i2c related warning.
> I also squashed the REGMAP_I2C dependency into patch #4.
> It's all in mfd-next now, I'd appreciate if you could double check it's all
> fine.

I checked out latest
git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git and
applied patches 5 - 10, 12. There doesn't seem to be any problems, so
I think MFD part of the driver is good to go.

>
> Mauro will take the rest, we made sure there won't be any merge conflict
> between our trees.

Mauro, I am not sure if you need me to rebase any of the patches(it
doesn't seem like you had a chance to make any further changes related
to this driver in media tree), but if you do, ping me and I'll get on
it.

>
> Cheers,
> Samuel.
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
