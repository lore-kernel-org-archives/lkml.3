Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaH1NW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 09:22:29 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:50936 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbaH1NW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 09:22:28 -0400
MIME-Version: 1.0
In-Reply-To: <1407768768-12033-1-git-send-email-kiran.padwal@smartplayin.com>
References: <1407768768-12033-1-git-send-email-kiran.padwal@smartplayin.com>
Date: Thu, 28 Aug 2014 15:22:27 +0200
Message-ID: <CACRpkdaruYw5xxDqc0-b0UCkEoOA=RZhAZdkmgCpRmYx3Pcg8w@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: imx6sl: Make of_device_id array const
From: Linus Walleij <linus.walleij@linaro.org>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 4:52 PM, Kiran Padwal
<kiran.padwal@smartplayin.com> wrote:

> Make of_device_id array const, because all OF functions handle it as const.
>
> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>

Patch applied and squashed with other device_id array constification.

Yours,
Linus Walleij
