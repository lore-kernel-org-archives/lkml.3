Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3BPDxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 22:53:24 -0500
Received: from ozlabs.org ([203.10.76.45]:51990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab3BPDxW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 22:53:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sjur =?utf-8?Q?Br=C3=A6ndeland?= <sjurbren@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ohad Ben-Cohen <ohad@wizery.com>,
        Vikram ARV <vikram.arv@stericsson.com>,
        Dmitry TARNYAGIN <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan YVIN <erwan.yvin@stericsson.com>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH vringh 2/2] caif_virtio: Introduce caif over virtio
In-Reply-To: <CAJK669YQ+x5zXSZA1FQHkRrcCt+SgZP-M_ea-Ey8ziGLhq9cqQ@mail.gmail.com>
References: <1360494273-27889-1-git-send-email-sjur.brandeland@stericsson.com> <1360494273-27889-3-git-send-email-sjur.brandeland@stericsson.com> <87vc9zfic8.fsf@rustcorp.com.au> <81C3A93C17462B4BBD7E272753C105792458EDD161@EXDCVYMBSTM005.EQ1STM.local> <87ehgklds9.fsf@rustcorp.com.au> <CAJK669YQ+x5zXSZA1FQHkRrcCt+SgZP-M_ea-Ey8ziGLhq9cqQ@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Feb 2013 15:05:42 +1030
Message-ID: <87bobmjish.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sjur Brændeland <sjurbren@gmail.com> writes:
> How about supporting struct vringh_kiov and struct kvec as well?
> I currently get the following complaints with my V2 patch-set:
>
> drivers/net/caif/caif_virtio.c:486:2: warning: passing argument 1 of
> ‘vringh_iov_init’ from incompatible pointer type [enabled by default]

vringh_kiov_init()?  Did I miss something else?

Cheers,
Rusty.
