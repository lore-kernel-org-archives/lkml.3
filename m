Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584AbaEGVY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:24:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270AbaEGVYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:24:21 -0400
Message-ID: <536AA482.8040506@suse.de>
Date: Wed, 07 May 2014 23:24:18 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn@kryo.se>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
References: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>	<20140507080650.GA28564@pengutronix.de> <CAJAp7OiVrz+epys3Ko79GmMr6ahv8ii8XphVHE77NSM+wK2mOA@mail.gmail.com>
In-Reply-To: <CAJAp7OiVrz+epys3Ko79GmMr6ahv8ii8XphVHE77NSM+wK2mOA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.05.2014 17:29, schrieb Bjorn Andersson:
> My problem is that the boot loader on every shipped Qualcomm MSM8x60, MSM8960
> and APQ8064 based device passes ATAG_MEM with the incorrect start address. There
> is no way to update the boot loader for these.

Chaining bootloaders comes to mind. This is being done on the Exynos5
based Chromebooks, for instance.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
