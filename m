Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaBRQ2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:28:54 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48389 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaBRQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:28:52 -0500
MIME-Version: 1.0
In-Reply-To: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com>
References: <1392738636-29877-1-git-send-email-fabio.estevam@freescale.com>
Date: Tue, 18 Feb 2014 21:58:52 +0530
Message-ID: <CAK9yfHykaoap7Dz+fsZgReRoXW_GsKvmZX7RDGqknd1_o3R50g@mail.gmail.com>
Subject: Re: [PATCH] pfuze100-regulator: Revert "regulator: pfuze100: Use of_get_child_by_name"
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        festevam@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 21:20, Fabio Estevam <fabio.estevam@freescale.com> wrote:
> Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we get
> the following probe failure:
>
> pfuze100-regulator 1-0008: Full layer: 1, Metal layer: 0
> pfuze100-regulator 1-0008: FAB: 0, FIN: 0
> pfuze100-regulator 1-0008: regulators node not found
> pfuze100-regulator: probe of 1-0008 failed with error -22
>
> Revert the offending commit so that we can probe the regulator successfully.

I wonder what is different in this case from the ones that I already
have working
that is causing this to fail. Can you please tell me which dts file
you have used
so that I can see if the way the node is defined is anything different.

 ---
With warm regards,
Sachin
