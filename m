Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3KSUPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:15:19 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50943 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3KSUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:15:15 -0500
MIME-Version: 1.0
In-Reply-To: <1384864362-21018-1-git-send-email-manishv.b@ti.com>
References: <1384864362-21018-1-git-send-email-manishv.b@ti.com>
Date: Tue, 19 Nov 2013 21:15:15 +0100
Message-ID: <CACRpkdb=NDnYDJe8y1CrkRsVpZCUiMQkf+u58MSp20uzjOa=BQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: Remove duplicate include of errno.h
From: Linus Walleij <linus.walleij@linaro.org>
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 1:32 PM, Vishwanathrao Badarkhe, Manish
<manishv.b@ti.com> wrote:

> From: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
>
> Currently, code include errno.h twice. Remove one inclusion
> of errno.h
>
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

Patch applied, thanks!

Yours,
Linus Walleij
