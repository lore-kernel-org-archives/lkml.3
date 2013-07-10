Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab3GJRmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:42:32 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63698 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab3GJRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:42:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130710052534.GB15674@arwen.pp.htv.fi>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
	<20130710052534.GB15674@arwen.pp.htv.fi>
Date: Wed, 10 Jul 2013 10:42:27 -0700
X-Google-Sender-Auth: q7ytjJjIZD2FtIhOUEqwUqz9DU8
Message-ID: <CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
From: Julius Werner <jwerner@chromium.org>
To: balbi@ti.com
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc@vger.kernel.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

This is intended to pull down a reset signal line, not to switch power
to the device. I could implement that with the regulator framework
too, but I think that would just be confusing and harder to understand
without providing any benefit. It's really just a plain old GPIO.
