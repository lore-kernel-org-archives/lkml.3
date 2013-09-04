Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab3IDQsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:48:30 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:62606 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908Ab3IDQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:48:28 -0400
MIME-Version: 1.0
In-Reply-To: <522760C9.8040201@ti.com>
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org>
	<1378276263-10735-7-git-send-email-sachin.kamat@linaro.org>
	<5227355C.1020205@ti.com>
	<CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com>
	<522760C9.8040201@ti.com>
Date: Wed, 4 Sep 2013 22:18:28 +0530
Message-ID: <CAK9yfHzq5isoj0bv405DNF_E=u0nKBBVscbcuoHT-8PxVaserA@mail.gmail.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, gg@slimlogic.co.uk,
        yong.shen@linaro.org, Sascha Hauer <s.hauer@pengutronix.de>,
        marek.vasut@gmail.com, Nancy.Chen@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2013 22:03, Nishanth Menon <nm@ti.com> wrote:
> On 09/04/2013 11:26 AM, Sachin Kamat wrote:

> I accept that probe failure gives me the required info for fail, and
> the cleanup of log prints also make sense, just that the log refactor
> seems out of context to the specific change.

As I mentioned earlier generally when you do these kind of
conversions, most of the trivial
clean-ups are also done along with it. Probably you would have
appreciated a mention about
this in the commit log too.

 --
With warm regards,
Sachin
