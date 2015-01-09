Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbbAIIpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:45:55 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:56111 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbbAIIpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:45:52 -0500
MIME-Version: 1.0
In-Reply-To: <4d544fe425694a4e8043ddbf604db062@BN1AFFO11FD033.protection.gbl>
References: <1d59c0972da04ec89dec6c09724986a1@BY2FFO11FD010.protection.gbl>
	<4d544fe425694a4e8043ddbf604db062@BN1AFFO11FD033.protection.gbl>
Date: Fri, 9 Jan 2015 09:45:52 +0100
Message-ID: <CACRpkdaKH21qz_RAcDtw6ycsw+5FD0RXQQs91_tZV53EuKVusQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Pinctrl support for Zynq
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 5:37 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:

> Argh, this went through the wrong SMTP. I suspect threading is broken
> due to that. Let me know if you want me to resend this with intact
> threading.

I don't care much about the threading, but all messages are quoted-printable
which doesn't apply :(

i.e.:

Content-Transfer-Encoding: quoted-printable
(...)

+ const char *subnode_target_type =3D "pins";
=20
(...)

Can you resent with more sane encoding? I don't know where this
comes from but suspect the Microsoft Exchange SMTP server
does this when you use diacritics and german letters...

Yours,
Linus Walleij
