Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab3BEO7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:59:45 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56106 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782Ab3BEO7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:59:44 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdY6=LL3LQA6-iO5gcTukd9=vp3+SnVJ7fSSDBGQZ28YSw@mail.gmail.com>
References: <1359720305-31933-1-git-send-email-blogic@openwrt.org>
	<CACRpkdY6=LL3LQA6-iO5gcTukd9=vp3+SnVJ7fSSDBGQZ28YSw@mail.gmail.com>
Date: Tue, 5 Feb 2013 15:59:42 +0100
Message-ID: <CACRpkdZxXVAGMJmjVzj4ck7VRiLTvdp9gqASdqkd_yNwEJAJXw@mail.gmail.com>
Subject: Re: [PATCH 01/11] PINCTRL: lantiq: pinconf uses port instead of pin
From: Linus Walleij <linus.walleij@linaro.org>
To: John Crispin <blogic@openwrt.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 3:39 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Feb 1, 2013 at 1:04 PM, John Crispin <blogic@openwrt.org> wrote:
>
>> The XWAY pinctrl driver invalidly uses the port and not the pin number to work
>> out the registeres and bits to be set for the opendrain and pullup/down
>> resistors.
>>
>> Signed-off-by: John Crispin <blogic@openwrt.org>
>
> Applied for fixes.

Actually after looking at this I start to wonder.

Is the current kernel actually enabling the Lantiq pinctrl
driver or is it not *actually* causing any regressions?

Can I just move all these fixes over to the devel
branch?

Yours,
Linus Walleij
