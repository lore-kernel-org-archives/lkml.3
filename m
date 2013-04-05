Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161308Ab3DEGP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 02:15:29 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:61040 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3DEGP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 02:15:28 -0400
MIME-Version: 1.0
In-Reply-To: <1363339796-14591-3-git-send-email-erwan.yvin@stericsson.com>
References: <1363339796-14591-1-git-send-email-erwan.yvin@stericsson.com>
	<1363339796-14591-3-git-send-email-erwan.yvin@stericsson.com>
Date: Fri, 5 Apr 2013 08:15:27 +0200
Message-ID: <CAJK669b8KzyT3AbN7Lw66DL5ANreiqnqjDnnRotO2Qh150rvXw@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: Add support for host virtio rings (vringh)
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Erwan Yvin <erwan.yvin@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Rusty Russel <rusty@ruscorp.com.au>,
        Ido Yariv <ido@wizery.com>, lkml <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Fri, Mar 15, 2013 at 10:29 AM, Erwan Yvin <erwan.yvin@stericsson.com> wrote:
> From: Erwan Yvin <erwan.yvin@stericsson.com>
>
> Implement the vringh callback functions in order
> to manage host virtio rings and handle kicks.
> This allows virtio device to request host-virtio-rings.
>
> Signed-off-by: Erwan Yvin <erwan.yvin@stericsson.com>

Any chance that you could review this in time for 3.10 merge window?
This is the last missing piece for host vring support.

The patches would have to be Acked/Reviewed by and should go via
Rusty's tree.

Thanks,
Sjur
