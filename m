Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab3KYOqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:46:17 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35909 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab3KYOqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:46:13 -0500
MIME-Version: 1.0
In-Reply-To: <7242109.um7KlGhuI2@amdc1227>
References: <1384881034-10520-1-git-send-email-t.figa@samsung.com>
	<528BB789.5020201@wwwdotorg.org>
	<7242109.um7KlGhuI2@amdc1227>
Date: Mon, 25 Nov 2013 15:46:12 +0100
Message-ID: <CACRpkdZHUfZinS20OFm+DkziiACxDOvJNhDMvdw3LdDbau1tCA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow grouping multiple pinmux/pinconf nodes
From: Linus Walleij <linus.walleij@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 3:00 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Stephen:
>> Is the lifetime of the string "returned" by
>> of_property_read_string_index() really so short that you must copy the
>> string? I'd be tempted just to store the pointer, although perhaps you
>> need to get() the node so that's safe.
>
> Right. I have done it the copy-less way in other places, but missed this
> one. Thanks.

So I guess I'm waiting for a new version of this patch, right?

Yours,
Linus Walleij
