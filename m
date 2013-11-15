Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3KOXaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:30:24 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36705 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3KOXaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:30:07 -0500
MIME-Version: 1.0
In-Reply-To: <20131115225234.GC2672@katana>
References: <1384462936-7906-1-git-send-email-tim.kryger@linaro.org>
	<20131115225234.GC2672@katana>
Date: Fri, 15 Nov 2013 15:30:06 -0800
Message-ID: <CAAYSxhrk6qgfy3TUdme3ge98d8Db7e=aW3LG8VfsJgjfuHAS3A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Add-Broadcom-Kona-I2C-Support
From: Tim Kryger <tim.kryger@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux Doc List <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linaro Patches List <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 2:52 PM, Wolfram Sang <wsa@the-dreams.de> wrote:

> Fixed Kconfig sorting, squashed broken out patches 1-3 into one and
> applied to for-next, thanks! Let me know if I should take patches 4-5
> also, but usually they go via arm-soc. Also, please provide a "Changes
> since V1" log which will speed up reviewing.

Thanks.  It appears that when I updated the dependencies, I
accidentally removed the change list I had planned to send.  This is
what should have appeared in my cover letter:

Changes in v2:
  - Binding documentation is in its own patch
  - Minor cosmetic changes
  - Fixed bug related to improper signedness
  - Removed superflous mutex
  - Simplified probe function

I think it would be best for the DTS changes (patches 4 and 5) to go
through Christian's tree.

-Tim
