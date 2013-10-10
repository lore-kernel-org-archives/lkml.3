Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3JJPfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:35:46 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:36638 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055Ab3JJPfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:35:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131009151015.GZ8313@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
	<20131003054218.8941.19273.stgit@localhost>
	<20131007173531.GX8949@atomide.com>
	<CACRpkdZ1CeSXJngo0gKpnag-=mT3FB-byJi3JSAWiS8hbHqBJA@mail.gmail.com>
	<20131009151015.GZ8313@atomide.com>
Date: Thu, 10 Oct 2013 17:35:44 +0200
Message-ID: <CACRpkdbX6RqP=ikap_4pq3BOuEt_7ZWv4JwS2NfhDn2up841Pg@mail.gmail.com>
Subject: Re: [PATCH 3/6] pinctrl: single: Prepare for supporting SoC specific features
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 5:10 PM, Tony Lindgren <tony@atomide.com> wrote:

> I was thinking I'll set up an immutable branch for the three
> pinctrl patches against -rc4 then both you and I can merge
> them in as needed. Does that work for you?

Hm it's fair enough to have them in your tree if they do
not collide ... especially if you want to do some of my
suggested follow-up moving the ioring handling down into
pinctrl-single on top of that.

> I can also do a test merge with pinctrl/for-next also to make
> sure there are no conflicts.

Sure, as long as that works you should be safe.

Yours,
Linus Walleij
