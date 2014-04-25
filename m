Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaDYJNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:13:33 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62017 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaDYJN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:13:28 -0400
MIME-Version: 1.0
In-Reply-To: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com>
Date: Fri, 25 Apr 2014 11:13:27 +0200
Message-ID: <CACRpkdYaX_9KRTTwvmxJXo-sG7AK2u-ggrNHY+FS3qQCQhudRA@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 5:51 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> This series adds support for the Marvell Berlin pin-controller, allowing
> to configure the pin muxing from the device tree.

I've looked over the patch series and there is nothing really controversial in
there, but I'm waiting for Thomas & Sebastian to provide Reviewed-by
tags.

Yours,
Linus Walleij
