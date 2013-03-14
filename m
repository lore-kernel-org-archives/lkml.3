Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3CNRiO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:38:14 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33425 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257Ab3CNRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:38:10 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabio Porcedda <fabio.porcedda@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 4/8] drivers: input: use module_platform_driver_probe()
Date: Thu, 14 Mar 2013 10:30:18 -0700 (PDT)
Message-ID: <3681471.ufqahH3gTF@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.9.5 (Linux/3.8.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1363280978-24051-5-git-send-email-fabio.porcedda@gmail.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com> <1363280978-24051-5-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On Thursday, March 14, 2013 06:09:34 PM Fabio Porcedda wrote:
> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.

I already have patches from Sachin Kamat for this, I am waiting for -rc3
to sync up with mainline and pick up the macro before applying them.

Thanks.

-- 
Dmitry
