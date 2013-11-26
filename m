Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3KZAcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:32:13 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:44768 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab3KZAcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:32:10 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Linus Walleij <linus.walleij@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow grouping multiple pinmux/pinconf nodes
Date: Tue, 26 Nov 2013 01:32:07 +0100
Message-ID: <2242006.0l244SkK9j@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CACRpkdZHUfZinS20OFm+DkziiACxDOvJNhDMvdw3LdDbau1tCA@mail.gmail.com>
References: <1384881034-10520-1-git-send-email-t.figa@samsung.com> <7242109.um7KlGhuI2@amdc1227> <CACRpkdZHUfZinS20OFm+DkziiACxDOvJNhDMvdw3LdDbau1tCA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 of November 2013 15:46:12 Linus Walleij wrote:
> On Wed, Nov 20, 2013 at 3:00 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> > Stephen:
> >> Is the lifetime of the string "returned" by
> >> of_property_read_string_index() really so short that you must copy the
> >> string? I'd be tempted just to store the pointer, although perhaps you
> >> need to get() the node so that's safe.
> >
> > Right. I have done it the copy-less way in other places, but missed this
> > one. Thanks.
> 
> So I guess I'm waiting for a new version of this patch, right?

Right.

Best regards,
Tomasz

