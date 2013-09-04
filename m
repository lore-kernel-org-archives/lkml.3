Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114Ab3IDRBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:01:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44956 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763050Ab3IDRBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:01:21 -0400
Message-ID: <5227674A.9020005@ti.com>
Date: Wed, 4 Sep 2013 12:00:58 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>, <marek.vasut@gmail.com>,
        <Nancy.Chen@freescale.com>
Subject: Re: [PATCH 7/7] regulator: ti-abb: Use devm_regulator_register
References: <1378276263-10735-1-git-send-email-sachin.kamat@linaro.org> <1378276263-10735-7-git-send-email-sachin.kamat@linaro.org> <5227355C.1020205@ti.com> <CAK9yfHxyyZ8WGL8Q4cJ7Y=LcJ2dkeZamXydnMYS4uOj-cmU_Dg@mail.gmail.com> <522760C9.8040201@ti.com> <CAK9yfHzq5isoj0bv405DNF_E=u0nKBBVscbcuoHT-8PxVaserA@mail.gmail.com>
In-Reply-To: <CAK9yfHzq5isoj0bv405DNF_E=u0nKBBVscbcuoHT-8PxVaserA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- yong.shen@linaro.org as it bounces.
On 09/04/2013 11:48 AM, Sachin Kamat wrote:
> On 4 September 2013 22:03, Nishanth Menon <nm@ti.com> wrote:
>> On 09/04/2013 11:26 AM, Sachin Kamat wrote:
> 
>> I accept that probe failure gives me the required info for fail, and
>> the cleanup of log prints also make sense, just that the log refactor
>> seems out of context to the specific change.
> 
> As I mentioned earlier generally when you do these kind of
> conversions, most of the trivial
> clean-ups are also done along with it. Probably you would have
> appreciated a mention about
> this in the commit log too.

yes, adding to commit log might have helped me. thanks for the cleanup
as well.


-- 
Regards,
Nishanth Menon
