Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaFZXxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 19:53:35 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41782 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaFZXxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 19:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAHfPSqC2sjkrpYz53QzW1PDSV2E9yfSEnE734JHH1zUONnh=rw@mail.gmail.com>
References: <1403785148-20792-1-git-send-email-ch.naveen@samsung.com>
	<CABxcv=nTfkRkpz_zZuxYHznjDuNgpiKO+FD4MnHi2C_2e32eqA@mail.gmail.com>
	<CAHfPSqC2sjkrpYz53QzW1PDSV2E9yfSEnE734JHH1zUONnh=rw@mail.gmail.com>
Date: Thu, 26 Jun 2014 16:53:31 -0700
X-Google-Sender-Auth: 19cSFifNoPgnOfe3DI_6WY6kqdU
Message-ID: <CAD=FV=U4NA2TaQWf8f4bL48dFG6T+k3vh_nRnWSM_VWivUFjoQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM: DTS: create common dtsi for Peach pit and pi boards
From: Doug Anderson <dianders@chromium.org>
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: Javier Martinez Canillas <javier@dowhile0.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "cpgs ." <cpgs@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naveen,

On Thu, Jun 26, 2014 at 9:38 AM, Naveen Krishna Ch
<naveenkrishna.ch@gmail.com> wrote:
> Will wait for few more opinions and make a fragment instead of common dtsi.
> Thank you a lot for the information and the references.

Just in case you're waiting for my opinion, I'll say that I'm of the
opinion that fragments will work better.

-Doug
