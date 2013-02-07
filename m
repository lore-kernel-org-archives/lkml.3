Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3BGPm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:42:29 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38730 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3BGPm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:42:28 -0500
MIME-Version: 1.0
In-Reply-To: <1360148051-7560-21-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
	<1360148051-7560-21-git-send-email-lee.jones@linaro.org>
Date: Thu, 7 Feb 2013 16:42:28 +0100
Message-ID: <CACRpkdaojJX8ZDxk1xVit7E4pXoFZLQfSJV3uxkBwt8=+MOC-Q@mail.gmail.com>
Subject: Re: [PATCH 20/49] ARM: ux500: regulators: List the MMIO camera as a
 consumer of VAUX1
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The MMIO camera uses the VAUX1 as it's voltage supply.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
