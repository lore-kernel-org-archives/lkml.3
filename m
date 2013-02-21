Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3BUNx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:53:59 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40178 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab3BUNx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:53:58 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.67.63]
In-Reply-To: <8738wqgok6.fsf@rustcorp.com.au>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com> <8738wqgok6.fsf@rustcorp.com.au>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Feb 2013 15:53:36 +0200
Message-ID: <CAK=WgbYt6mQeJ+4kCFsfGppfaq3JcS6OedNE+ZGd4itfR1hU4A@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>,
        netdev@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 8:37 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Hmm... I clearly jumped the gun, assuming consensus was already reached.
> I have put these patches *back* into pending-rebases, and they will not
> be merged this merge window.

Thanks.

What do you think about creating some virtio-level wrappers for the
vringh handlers?

I don't think we're going to stop with caif as the only vringh user,
and it could be nice if we follow the virtio spirit of decoupling the
drivers from the low level implementation. It sure did prove itself
when the remoteproc use cases started showing up, and it's neat.

Thanks,
Ohad.
