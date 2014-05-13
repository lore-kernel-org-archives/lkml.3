Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbaEMGmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:42:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37903 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaEMGmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:42:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140509095545.GO5767@lee--X1>
References: <1399583799-23517-1-git-send-email-linus.walleij@linaro.org>
	<20140509093111.GN5767@lee--X1>
	<20140509095545.GO5767@lee--X1>
Date: Tue, 13 May 2014 08:42:05 +0200
Message-ID: <CACRpkdbrew30s8U43JVLLeK3z=oebjj9shhm98vaAZnrKwK0nQ@mail.gmail.com>
Subject: Re: [GIT PULL v2] First pull-request for the IB between MFD and GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 11:55 AM, Lee Jones <lee.jones@linaro.org> wrote:

> Looks like it matters which order the patches are merged in - my bad!
>
> The following changes since commit 89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:
>
>   Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/ib-mfd-gpio-v3.16
>
> for you to fetch changes up to 3ba1d516d5feddba3e13d30d31a70da130a3ee0e:
>
>   mfd: stmpe: root out static GPIO and IRQ assignments (2014-05-09 10:51:14 +0100)

OK I first merged in v3.15-rc4 to my devel branch and then pulled this
on top and all
seems to be working well :-)

Thanks a ton Lee!

Yours,
Linus Walleij
