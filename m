Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbaBYCSK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:18:10 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:49995 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbaBYCSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:18:08 -0500
MIME-Version: 1.0
In-Reply-To: <20140225013424.GL25940@sirena.org.uk>
References: <1392914164-28596-1-git-send-email-mpa@pengutronix.de>
	<20140223051209.GK25940@sirena.org.uk>
	<CAOMZO5BPvCcx_f09Khuw8MVxrR18fnv9e1xeuJ0c_8G22AR53g@mail.gmail.com>
	<20140224205058.GA18317@pengutronix.de>
	<20140225013424.GL25940@sirena.org.uk>
Date: Mon, 24 Feb 2014 23:18:08 -0300
Message-ID: <CAOMZO5ATGZB=PZzgK71mJyf10o1WvJuYQtxsiOjkMB3r9WqQ=A@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] regulator: core: Fix ops->enable/disable usage
From: Fabio Estevam <festevam@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Markus Pargmann <mpa@pengutronix.de>, Sascha Hauer <kernel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 10:34 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Feb 24, 2014 at 09:50:58PM +0100, Markus Pargmann wrote:
>
>> The only situation where this returns -EINVAL is a dummy regulator that
>> is not always_on. As it doesn't make sense to have a dummy regulator
>> that is not always_on, I will add a check for exactly this situation to
>> the regulator_register function and drop the "return -EINVAL" above.
>
> I've squashed the following fix in today:

Thanks. This fixes the issue.
