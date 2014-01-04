Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbaADQAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 11:00:54 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33133 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbaADQAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 11:00:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140104000213.GA23926@core.coreip.homeip.net>
References: <1387809881-16092-1-git-send-email-festevam@gmail.com>
	<20131224130357.GD30815@sirena.org.uk>
	<20140104000213.GA23926@core.coreip.homeip.net>
Date: Sat, 4 Jan 2014 14:00:52 -0200
Message-ID: <CAOMZO5Bg1fMGBbYYkVTNh-ENPovkZ9t-sD92e4fGV+_oKTG9cg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] regulator: anatop-regulator: Fix the error
 handling on probe
From: Fabio Estevam <festevam@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Fri, Jan 3, 2014 at 10:02 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Tue, Dec 24, 2013 at 01:03:57PM +0000, Mark Brown wrote:
>> On Mon, Dec 23, 2013 at 12:44:40PM -0200, Fabio Estevam wrote:
>> > From: Fabio Estevam <fabio.estevam@freescale.com>
>> >
>> > Currently when of_get_parent() or syscon_node_to_regmap() fail
>> > 'kfree(sreg->name)' is not called, which is incorrect.
>>
>> Applied both, thanks.
>
> Sorry for being too later, but why are we making copy to begin with? It
> is not like DT data will disappear later on.

Which lines of code are you referring to, please?

Regards,

Fabio Estevam
