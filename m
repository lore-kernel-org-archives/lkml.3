Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbaEPQYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:24:39 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49505 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757965AbaEPQYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <20140513221313.GI20486@codeaurora.org>
References: <1398759492-12970-1-git-send-email-srinivas.kandagatla@linaro.org>
	<1398759542-13017-1-git-send-email-srinivas.kandagatla@linaro.org>
	<CACRpkdZyEAkJUGC5x6CY65-g97jfyg-TMDoe8JxDMexVx5usSA@mail.gmail.com>
	<5371E8B7.8000103@linaro.org>
	<20140513221313.GI20486@codeaurora.org>
Date: Fri, 16 May 2014 18:24:37 +0200
Message-ID: <CACRpkdZe7NA0CxB=ArWwSRt_BF69sG=BHBz+DY1H4AbabNhC=A@mail.gmail.com>
Subject: Re: [PATCH v1 01/11] ARM: amba: Add Qualcomm vendor ID.
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        agross@quicinc.com,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:13 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Please add a note that this id is fake in the commit text or in
> the code as well.

You just need one of your hardware engineers to add is to one instance
of some test chip round so it exists in any hardware whatsoever and it
is not "fake" anymore...

This is a bit like device tree, it's defined by the kernel community as much
as by the hardware engineers and it's a little bit of back-and-forth.

Yours,
Linus Walleij
