Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3BPIsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:48:51 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:36785 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab3BPIst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:48:49 -0500
MIME-Version: 1.0
In-Reply-To: <87bobmjish.fsf@rustcorp.com.au>
References: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com>
	<1360494273-27889-3-git-send-email-sjur.brandeland@stericsson.com>
	<87vc9zfic8.fsf@rustcorp.com.au>
	<81C3A93C17462B4BBD7E272753C105792458EDD161@EXDCVYMBSTM005.EQ1STM.local>
	<87ehgklds9.fsf@rustcorp.com.au>
	<CAJK669YQ+x5zXSZA1FQHkRrcCt+SgZP-M_ea-Ey8ziGLhq9cqQ@mail.gmail.com>
	<87bobmjish.fsf@rustcorp.com.au>
Date: Sat, 16 Feb 2013 09:48:48 +0100
Message-ID: <CAJK669ZATh8FojTGdFH_x7ovMvA2L7XFUratiptJmPFZPhv31g@mail.gmail.com>
Subject: Re: [PATCH vringh 2/2] caif_virtio: Introduce caif over virtio
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjurbren@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, Ohad Ben-Cohen <ohad@wizery.com>,
        Vikram ARV <vikram.arv@stericsson.com>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sjur Brændeland <sjurbren@gmail.com> writes:
>> How about supporting struct vringh_kiov and struct kvec as well?
>> I currently get the following complaints with my V2 patch-set:
>>
>> drivers/net/caif/caif_virtio.c:486:2: warning: passing argument 1 of
>> ‘vringh_iov_init’ from incompatible pointer type [enabled by default]
>
> vringh_kiov_init()?  Did I miss something else?

I get a warning for my useof vringh_iov_cleanup() in
addition to the one above.

How about adding kiov variants of  vringh_iov_cleanup()
and vringh_iov_reset() as well?

Thanks,
Sjur
