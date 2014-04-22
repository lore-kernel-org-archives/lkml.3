Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbaDVM4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:56:18 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:55710 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaDVMzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:55:41 -0400
MIME-Version: 1.0
In-Reply-To: <1397227564-8698-1-git-send-email-christian.ruppert@abilis.com>
References: <20140402111358.GA23000@mwanda>
	<1397227564-8698-1-git-send-email-christian.ruppert@abilis.com>
Date: Tue, 22 Apr 2014 14:55:40 +0200
Message-ID: <CACRpkdZwG4pdczNLZdMi3V=wFqPOxWpbME8P-Y2m5ypAn7EU=Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/TB10x: Fix signedness bug
From: Linus Walleij <linus.walleij@linaro.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 4:46 PM, Christian Ruppert
<christian.ruppert@abilis.com> wrote:

> In the TB10x pin database, a port index of -1 is used to indicate
> unmuxed GPIO pin groups. This bug fixes a 'cast to unsigned' bug of
> this value.
>
> Thanks to Dan Carpenter for highlighting this.
>
> CC: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>

Patch applied for fixes.

Yours,
Linus Walleij
