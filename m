Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3BURzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:55:38 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61491 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3BURzf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:55:35 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.70.35]
In-Reply-To: <CAJK669YHwR=nf2zSQR6buaA-x1JSowJfU16hkz1+N_WLL0qA+A@mail.gmail.com>
References: <1360669793-6921-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360669793-6921-2-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgbb0EeiCh504jsoX+izzi+ZogfEDttz2cHRd4pVXvQunQw@mail.gmail.com>
 <CAJK669bDu3SphxmEtA+h+v=btsN91t0S9Mn6ik-OKr=8gtducw@mail.gmail.com>
 <CAK=Wgba5XkK3c7qh1tYHMGEe7-Qima96uYO4E+uAPcaB8K6bmQ@mail.gmail.com> <CAJK669YHwR=nf2zSQR6buaA-x1JSowJfU16hkz1+N_WLL0qA+A@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Feb 2013 19:55:13 +0200
Message-ID: <CAK=Wgbam=Y5GJQxg2DSt2yR6CdcDxjZ5k_Av_0H8+6m+scN+Yw@mail.gmail.com>
Subject: Re: [PATCHv2 vringh 1/3] remoteproc: Add support for vringh (Host vrings)
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Feb 21, 2013 at 7:28 PM, Sjur Brændeland <sjurbren@gmail.com> wrote:
> The motivation for using vringh was to avoid copying buffers
> when sending data from the modem to the host.

I may be missing something here, but why do you need vringh for that?

With rpmsg (which uses two regular vrings) both ends send huge amount
of data without copying it - we just send the pointers across.

Thanks,
Ohad.
