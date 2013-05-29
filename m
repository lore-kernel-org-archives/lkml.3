Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717Ab3E2Sq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:46:57 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:48026 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965413Ab3E2Sqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:46:48 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:4978:ebac:5b1e:deda]
In-Reply-To: <000001ce5c4f$839f4cb0$8adde610$@samsung.com>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
	<87sj1qzaov.fsf@linaro.org>
	<5191AA89.6010901@linaro.org>
	<20130528231740.GA28879@quad.lixom.net>
	<51A57D39.8030506@linaro.org>
	<CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
	<51A5C16D.20408@linaro.org>
	<000001ce5c4f$839f4cb0$8adde610$@samsung.com>
Date: Wed, 29 May 2013 11:46:47 -0700
Message-ID: <CAOesGMiYs6GfaWGWYB8cw_cJ6_RmmZTb4oPfXo1PYJT8-jdHzw@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
From: Olof Johansson <olof@lixom.net>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Tushar Behera <tushar.behera@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Patch Tracking <patches@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 2:33 AM, Jingoo Han <jg1.han@samsung.com> wrote:

> However, Olof Johansson mentioned, 'drivers/platform/arm/board_arndale.c'
> would be a good alternative.


Whoa. I didn't quite realize what I proposed, or rather, how what I
proposed could be perceived. I take it back. :)

We must _not_ introduce something that will be abused as a new home
for board file junk. If we do introduce a platform glue directory it
would need to be very limited in scope. Compare to what's in
drivers/platform/x86 today.


-Olof
