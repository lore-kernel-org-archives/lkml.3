Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab3CLM31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:29:27 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:34825 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab3CLM30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:29:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130312120648.GB27461@S2101-09.ap.freescale.net>
References: <1363045937-6740-1-git-send-email-festevam@gmail.com>
	<20130312120648.GB27461@S2101-09.ap.freescale.net>
Date: Tue, 12 Mar 2013 20:29:25 +0800
Message-ID: <CAAQ0ZWQTJMPMH9QQ7Z_i+9egt3LVpsQsE_AAu9T+-5ptnPJtHQ@mail.gmail.com>
Subject: Re: [PATCH] video: mxsfb: Convert to devm_ioremap_resource()
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2013 20:06, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Mon, Mar 11, 2013 at 08:52:17PM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Converting to devm_ioremap_resource() can make the code cleaner and smaller.
>>
> While you are there, you may want to use devm_kzalloc() and
> devm_clk_get() as well.
>
Actually I'm working on a series to convert mxsfb driver to generic
of_videomode bindings, and already had a cleanup patch to move all
these calls to managed functions.  To ease the merge process, I plan
to have the series go via arm-soc tree.

Shawn
