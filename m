Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3ENMTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:19:33 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:33056 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab3ENMTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:19:32 -0400
MIME-Version: 1.0
In-Reply-To: <1368173847-5661-19-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
	<1368173847-5661-19-git-send-email-wsa@the-dreams.de>
Date: Tue, 14 May 2013 14:19:31 +0200
Message-ID: <CACRpkda8gNhcqCa6Yv7J1kHHz+EhrpYGQn=h_JMNCXbbOdMt1A@mail.gmail.com>
Subject: Re: [RFC 18/42] drivers/pinctrl: don't check resource with devm_ioremap_resource
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 10:17 AM, Wolfram Sang <wsa@the-dreams.de> wrote:

> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Patch applied with Jean-Christophe's ACK.

Thanks!
Linus Walleij
