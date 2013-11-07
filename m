Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab3KGXjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:39:03 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:62071 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3KGXis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:38:48 -0500
MIME-Version: 1.0
In-Reply-To: <1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
References: <1383676898-29819-1-git-send-email-panto@antoniou-consulting.com>
	<1383676898-29819-4-git-send-email-panto@antoniou-consulting.com>
Date: Thu, 7 Nov 2013 17:38:46 -0600
Message-ID: <CANk1AXSHDDh1HrD_iBLNxopCrDqcDmoQs93i17UvGFtYR5_mEQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] DT: proc: Add runtime overlay interface in /proc
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 12:41 PM, Pantelis Antoniou
<panto@antoniou-consulting.com> wrote:
> +
> +       pr_info("%s: Applied #%d overlay segments @%d\n", __func__,
> +                       od->ovinfo_cnt, od->id);
> +

This could be pr_debug so that we get normally get silence unless
something fails, like insmod.

Also please take out the '#'.

We see it working with our fpga ip driver and it looks really great.

Alan
