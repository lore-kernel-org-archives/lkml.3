Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbbAIJnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:43:01 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:58779 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbbAIJm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:42:58 -0500
MIME-Version: 1.0
In-Reply-To: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1417689170-41627-1-git-send-email-mika.westerberg@linux.intel.com>
Date: Fri, 9 Jan 2015 10:42:57 +0100
Message-ID: <CACRpkdYspQf6UPBjxNu-o1PXn9jfc8xbBPNqSKRa4t6EafFvAA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: intel: Pass CONFIG_DEBUG_PINCTRL to drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2014 at 11:32 AM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> If the user has selected CONFIG_DEBUG_PINCTRL=y make sure that Intel
> pinctrl drivers will be compiled with that option as well.
>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Patch applied, and conjured a patch doing the same on the other
subdirs so all pinctrl drivers have the -DDEBUG flag set when
configured it.

Thanks for fixing this and pointing the problem out.

Yours,
Linus Walleij
