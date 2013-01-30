Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3A3R1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:27:52 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:60893 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3A3R1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:27:49 -0500
Message-ID: <5109580B.2050309@wwwdotorg.org>
Date: Wed, 30 Jan 2013 10:27:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/1] pinctrl: nomadik: Rename Device Tree compatible string
References: <1359563102-5934-1-git-send-email-linus.walleij@stericsson.com> <51094E50.4000302@wwwdotorg.org> <20130130170750.GA5217@gmail.com>
In-Reply-To: <20130130170750.GA5217@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 10:07 AM, Lee Jones wrote:
> The preference is to use '-' instead of '_' in compatible strings.

OK, this version seems complete. One issue here is that older device
trees now won't work with newer kernels since the driver's support of
the original compatible value is removed. DT is supposed to be backwards
compatible, but perhaps at this earlyish stage you don't care about this
on your platform yet?
