Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3KYXLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:11:32 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:54129 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3KYXL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:11:28 -0500
MIME-Version: 1.0
In-Reply-To: <1382533861-12688-1-git-send-email-dianders@chromium.org>
References: <1382533861-12688-1-git-send-email-dianders@chromium.org>
Date: Mon, 25 Nov 2013 15:11:27 -0800
X-Google-Sender-Auth: c7SvY7-w-NOhyQ5ohWI145TEEMw
Message-ID: <CAD=FV=VHLHL-VxUr_G7CoBQ5UY8t1jbdTCwcGz9BYrR5C3cpAQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: Add max77686 RTC interrupt to cros5250-common
From: Doug Anderson <dianders@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>
Cc: marc.zyngier@arm.com, Doug Anderson <dianders@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof or Kukjin,

On Wed, Oct 23, 2013 at 6:11 AM, Doug Anderson <dianders@chromium.org> wrote:
> Without the interrupt you'll get problems if you enable
> CONFIG_RTC_DRV_MAX77686.  Setup the interrupt properly in the device
> tree.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/cros5250-common.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Would one of you be interested in applying this to your tree, with
Marc's "Tested-by"?  I know there are lots more things to fixup in the
dts, but this is one that I know works.  ;)

-Doug
