Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964892Ab3CNRwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:52:23 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:57514 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608Ab3CNRwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:52:19 -0400
MIME-Version: 1.0
In-Reply-To: <3681471.ufqahH3gTF@dtor-d630.eng.vmware.com>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-5-git-send-email-fabio.porcedda@gmail.com> <3681471.ufqahH3gTF@dtor-d630.eng.vmware.com>
From: Fabio Porcedda <fabio.porcedda@gmail.com>
Date: Thu, 14 Mar 2013 18:51:58 +0100
Message-ID: <CAHkwnC-vOPxqWq3jF=sbDrhvyWhNYvV5rAd69K8b5iH3KyqyPQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] drivers: input: use module_platform_driver_probe()
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-media <linux-media@vger.kernel.org>,
        linux-ide <linux-ide@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Linus Walleij <linus.walleij@linaro.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 6:30 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Fabio,
>
> On Thursday, March 14, 2013 06:09:34 PM Fabio Porcedda wrote:
>> This patch converts the drivers to use the
>> module_platform_driver_probe() macro which makes the code smaller and
>> a bit simpler.
>
> I already have patches from Sachin Kamat for this, I am waiting for -rc3
> to sync up with mainline and pick up the macro before applying them.

Thank for reviewing.

I've sent a updated patch without the patch already sent by Sachin Kamat.

Best regards
Fabio Porcedda

> Thanks.
>
> --
> Dmitry
