Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3KYJHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:07:35 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37155 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3KYJHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:07:31 -0500
MIME-Version: 1.0
In-Reply-To: <20131125085831.GO2281@intel.com>
References: <1385186069-28986-1-git-send-email-acourbot@nvidia.com> <20131125085831.GO2281@intel.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 25 Nov 2013 18:07:10 +0900
Message-ID: <CAAVeFu+wFAqroiyzwRQLkRAmhVQV-efOYA51DTHUwMMA1nTYxA@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: add missing declarations
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 5:58 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Sat, Nov 23, 2013 at 02:54:29PM +0900, Alexandre Courbot wrote:
>> Add missing declarations and include files to avoid warnings during
>> compilation of include/gpio/driver.h.
>
> It would be good to have those warnings included in the changelog as well.

As in, copy-pasting the compiler's output? Isn't the change explicit enough?
