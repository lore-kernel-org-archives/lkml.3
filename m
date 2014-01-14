Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaANJfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:35:05 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:53546 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaANJfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:35:01 -0500
MIME-Version: 1.0
In-Reply-To: <1389084056-17076-1-git-send-email-ldewangan@nvidia.com>
References: <1389084056-17076-1-git-send-email-ldewangan@nvidia.com>
Date: Tue, 14 Jan 2014 10:35:00 +0100
Message-ID: <CACRpkdYfPKr7VGPGSifVnG_xwifstQnLsHBxZkZQOt6vqnr6JQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: as3722: Set pin to output mode for some function
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 9:40 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> From: Mallikarjun Kasoju <mkasoju@nvidia.com>
>
> If pins are used for function output like pwm, clk32k,
> power good etc then set it as output mode default.
>
> Signed-off-by: Mallikarjun Kasoju <mkasoju@nvidia.com>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Patch applied with Lee's ACK.

Yours,
Linus Walleij
