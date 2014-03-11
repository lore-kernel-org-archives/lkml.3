Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaCKK1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:27:45 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:41311 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555AbaCKK1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:27:13 -0400
MIME-Version: 1.0
In-Reply-To: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com>
References: <1394114389-27106-1-git-send-email-chiau.ee.chew@intel.com>
Date: Tue, 11 Mar 2014 11:27:13 +0100
Message-ID: <CACRpkdajaffBOmc9KeUyLkwZth6vNu-Z0Ln+Xf4ZV0gZ9Ytf_g@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: add function mux checking in gpio pin request
From: Linus Walleij <linus.walleij@linaro.org>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 2:59 PM, Chew Chiau Ee <chiau.ee.chew@intel.com> wrote:

> From: Chew, Kean Ho <kean.ho.chew@intel.com>
>
> The requested gpio pin must has the func_pin_mux field set
> to GPIO function by BIOS/FW in advanced. Else, the gpio pin
> request would fail. This is to ensure that we do not expose
> any gpio pins which shall be used for alternate functions,
> for eg: wakeup pin, I/O interfaces for LPSS, etc.
>
> Signed-off-by: Chew, Kean Ho <kean.ho.chew@intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Patch applied with Darren's ACK.

This confirms my suspicion that you will not be able to
hide the pin control interface side of this hardware forever. ;-)

Mika/Mathias: any comments?

Yours,
Linus Walleij
