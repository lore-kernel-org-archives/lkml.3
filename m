Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaBSDcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:32:54 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35854 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaBSDcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:32:53 -0500
MIME-Version: 1.0
In-Reply-To: <1392777974-26254-1-git-send-email-festevam@gmail.com>
References: <1392777974-26254-1-git-send-email-festevam@gmail.com>
Date: Wed, 19 Feb 2014 09:02:52 +0530
Message-ID: <CAK9yfHzaUhBTooqF8+ywGgAS4kob7MTxOv0ncLifmYws0crpAA@mail.gmail.com>
Subject: Re: [PATCH] pfuze100-regulator: Fix of_node_get() parameter
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 February 2014 08:16, Fabio Estevam <festevam@gmail.com> wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
> the following probe failure:
>
> pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
> pfuze100-regulator 1-0008: FAB: 0, FIN: 0
> pfuze100-regulator 1-0008: regulators node not found
> pfuze100-regulator: probe of 1-0008 failed with error -22
>
> Now that of_get_child_by_name() is used we should adjust the device_node pointer
> 'np' to not get the parent node anymore.
>
> Suggested-by: Shawn Guo <shawn.guo@linaro.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Thanks for the fix Fabio.
Acked-by: Sachin Kamat <sachin.kamat@linaro.org>

Mark,
There are a few more instances that should be fixed like this one. How would you
prefer to handle them - Resend the complete patch or send just the
incremental fix?

-- 
With warm regards,
Sachin
