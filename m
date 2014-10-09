Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbaJIQyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 12:54:55 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:53721 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaJIQys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:54:48 -0400
MIME-Version: 1.0
In-Reply-To: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
References: <1412872877-1771-1-git-send-email-linux@roeck-us.net>
Date: Thu, 9 Oct 2014 18:54:48 +0200
Message-ID: <CACna6rzOeGcKrrftLx_3uWe_bAXQaQMmWb3wWHP0CjtdO8D0eg@mail.gmail.com>
Subject: Re: [PATCH] bcma: Add dependency on OF_ADDRESS
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 18:41, Guenter Roeck <linux@roeck-us.net> wrote:
> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> introduces a hard dependency on OF_ADDRESS into the bcma driver.
> OF_ADDRESS is specifically disabled for the sparc architecture.
> This results in the following error when building sparc64:allmodconfig.

Won't this make bcma im-POSSIBLE on MIPS? And maybe x86(_64), or at
least add an unneeded dependency? I think we should somehow limit this
to BCM5301X arch.
