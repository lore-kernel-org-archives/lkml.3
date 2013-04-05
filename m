Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161656Ab3DEF7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:59:53 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:45556 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161485Ab3DEF7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:59:52 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.123.88]
In-Reply-To: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 5 Apr 2013 08:59:29 +0300
Message-ID: <CAK=WgbYX0ghFSmv3-U52icVTv4gr8FH5aUZyeQiykXv=uO9ZxQ@mail.gmail.com>
Subject: Re: [PATCHv2 00/10] remoteproc: Support bi-directional vdev config space
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Ido Yariv <ido@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 7:15 PM, <sjur.brandeland@stericsson.com> wrote:
>
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> This patch-set adds support for shared resource table between
> Linux kernel and remote devices.
> - dynamically-allocated address of the vrings can be communicated
> - vdev statuses can be communicated
> - virtio config space becomes bi-directional
> - virtio feature negotiation is two-way
>
> Changes since v1:
> - Address all of Ido's review comments on the previous patch-set.

At long last I've applied and pushed out the patches, after some
changes to make it easier to read the code. These are mostly
style/terminology changes, as well as some cleanups and sporadic
addition of function documentation. Patches have also been rebased -
thanks Sjur for helping that feat privately.

The fixes were pushed to the fixes branch of remoteproc, and will be
pushed to Linus ASAP. The patches that add new functionality were
pushed to the for-next branch, and will subsequently show up in
linux-next. These will be pushed to Linus as soon as the next merge
window opens.

Sjur thanks for your effort and cooperation all along - the patches are great!

And sorry again for the delay - it was a hectic time and hopefully
we're back on track now.

Thanks,
Ohad.
