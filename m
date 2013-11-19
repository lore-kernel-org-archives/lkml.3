Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3KSSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:46:19 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52459 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3KSSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:46:15 -0500
Message-ID: <528BB1F2.4080107@wwwdotorg.org>
Date: Tue, 19 Nov 2013 11:46:10 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org
CC: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized using
 pinfunc.
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 10:15 AM, Tomasz Figa wrote:
> This patch extends the range of settings configurable via pinfunc API
> to cover pin value as well. This allows configuration of default values
> of pins.

Shouldn't there be a driver that acquires the GPIO that's output to the
pin, and configures the output value? IIRC there have been previous
discussions re: having a list of e.g. initial GPIO output values in DT,
and that was rejected, and this patch seems to be doing almost the exact
same thing, just at the pinctrl level rather than GPIO level.

That all said, I admit this could be a useful feature...
