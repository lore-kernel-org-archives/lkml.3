Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3LMJh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:37:29 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43292 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab3LMJhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:37:25 -0500
MIME-Version: 1.0
In-Reply-To: <0bc301cef7e5$319ac0c0$94d04240$@kernel.org>
References: <1378889173-7437-1-git-send-email-jose.goncalves@inov.pt>
	<CACRpkdYbCzOJ9k8AyriM9quafx=dseK6w1DYjyrJ9F53ka8TEw@mail.gmail.com>
	<52AA6909.8050200@inov.pt>
	<0bc301cef7e5$319ac0c0$94d04240$@kernel.org>
Date: Fri, 13 Dec 2013 10:37:25 +0100
Message-ID: <CACRpkdbQNEj83fnDX0ppPNJYgu1cMGxbk6n6M05wVNK9LEvDKw@mail.gmail.com>
Subject: Re: [PATCH] ARM: S3C24XX: Fix configuration of gpio port sizes on S3C24XX.
From: Linus Walleij <linus.walleij@linaro.org>
To: Kukjin Kim <kgene@kernel.org>
Cc: =?ISO-8859-1?Q?Jos=E9_Miguel_Gon=E7alves?= <jose.goncalves@inov.pt>,
        Tomasz Figa <t.figa@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:24 AM,  <kgene@kernel.org> wrote:
> José Miguel Gonçalves wrote:
(..)
>> Was this patch forgotten?
>>
> Hi Jose,
>
> Sorry about missing your patch. It's my fault :( and as you know, at this
> moment the file will be removed by Linus' patch...

Oh I can certainly rebase the patch onto my tree if I just
get an ACK for it...

Yours,
Linus Walleij
