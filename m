Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283AbaAaKR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:17:26 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47097 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbaAaKRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Fri, 31 Jan 2014 11:17:23 +0100
Message-ID: <CACRpkda5HRxpLWWizT_58SJ6Fb=TQpO=Y5yFThpZkUbUYmU8fg@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove hardcoded
 addresses from Dove pinctrl
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 1:39 AM, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:

> This patch set is one required step for Dove to hop into mach-mvebu.
> Until now, pinctrl-dove was hardcoding some registers that do not
> directly belong to MPP core registers. This is not compatible with
> what we want for mach-mvebu.

All this stuff is really nice, so if you can get Thomas to add his
review-tag on this stuff and maybe have some Tested-by:s
from other parties, I'd be happy to pull the end result to the
pinctrl tree, or alternatively provide my ACK for you to take this
through ARM SoC.

Yours,
Linus Walleij
