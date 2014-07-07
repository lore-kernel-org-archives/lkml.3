Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaGGO4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 10:56:30 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:55002 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbaGGO42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 10:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140617150738.GL29841@lee--X1>
References: <1401773164-30326-1-git-send-email-lejun.zhu@linux.intel.com>
	<20140617150738.GL29841@lee--X1>
Date: Mon, 7 Jul 2014 16:56:28 +0200
Message-ID: <CACRpkdY_5yD_7Yw=8GuW8DP4uXA1a=efQGymFjEMradEJDi7eQ@mail.gmail.com>
Subject: Re: [GIT PULL] LinusW - Immutable branch between MFD and GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Zhu, Lejun" <lejun.zhu@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 5:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
>
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-gpio-v3.17
>
> for you to fetch changes up to 104fb1d5153c563f453cb9c048fa0a17318a2348:
>
>   gpio: Add support for Intel Crystal Cove PMIC (2014-06-17 15:59:52 +0100)

I think I'll just optimistically assume this will merge nicely for v3.17.
Less trouble, and does not require MFD to be merged before the GPIO
tree in the merge window :-)

Yours,
Linus Walleij
