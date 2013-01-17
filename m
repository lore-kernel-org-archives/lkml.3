Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3AQL1r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:27:47 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43495 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3AQL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:27:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130114141504.C91503E232D@localhost>
References: <1358160800-12185-1-git-send-email-thierry.reding@avionic-design.de>
	<20130114141504.C91503E232D@localhost>
Date: Thu, 17 Jan 2013 12:27:45 +0100
Message-ID: <CACRpkda7vn++n1TVZdPFjDvnSJGgX8axN7eA3-9xBetMf=eNKA@mail.gmail.com>
Subject: Re: [PATCH] gpio: mvebu: Don't free chip label memory
From: Linus Walleij <linus.walleij@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 3:15 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, 14 Jan 2013 11:53:20 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
>> The gpio_chip.label field is a const char * and assigned the value of a
>> call to dev_name(). Memory obtained from dev_name() should not be freed
>> by drivers.
>>
>> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Yepps, patch applied.

Yours,
Linus Walleij
