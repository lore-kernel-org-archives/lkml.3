Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3DYLh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:37:28 -0400
Received: from mail-ia0-f169.google.com ([209.85.210.169]:60530 "EHLO
	mail-ia0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3DYLh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:37:26 -0400
MIME-Version: 1.0
In-Reply-To: <1366279934-30761-28-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-28-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 13:37:26 +0200
Message-ID: <CACRpkdZiXb-sKW+WhWyFFvXwW1V+EEUhZFLHhZKYh5Utp1tWtw@mail.gmail.com>
Subject: Re: [PATCH 27/32] ARM: ux500: Stop registering DMA40 from platform
 data when DT is enabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:12 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Now the DMA40 has been DT:ed, there's no requirement to register it
> using traditional methods. This is the penultimate device to be DT:ed.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
