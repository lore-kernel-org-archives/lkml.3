Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaBEJhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:37:53 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:43846 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaBEJhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:37:50 -0500
MIME-Version: 1.0
In-Reply-To: <1391202481-19533-1-git-send-email-david.a.cohen@linux.intel.com>
References: <20140131205007.GB26770@psi-dev26.jf.intel.com>
	<1391202481-19533-1-git-send-email-david.a.cohen@linux.intel.com>
Date: Wed, 5 Feb 2014 10:37:49 +0100
Message-ID: <CACRpkdbmhWkq8BRTgSGQsSwGbz1t3dzEww6ibAT2nWZuTTyncg@mail.gmail.com>
Subject: Re: [PATCH v2] gpio-intel-mid: fix the incorrect return of idle callback
From: Linus Walleij <linus.walleij@linaro.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xinhui.pan" <xinhuiX.pan@intel.com>, "bo.he" <bo.he@intel.com>,
        Felibe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 10:08 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:

> From: "xinhui.pan" <xinhuiX.pan@intel.com>
>
> intel_gpio_runtime_idle should return correct error code if it do fail.
> make it more correct even though -EBUSY is the most possible return value.
>
> Signed-off-by: bo.he <bo.he@intel.com>
> Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> Cc: Felibe Balbi <balbi@ti.com>

Patch applied with Felipe's Reviewed-by tag.

Yours,
Linus Walleij
