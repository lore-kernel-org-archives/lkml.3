Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3CLMOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:14:09 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48149 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3CLMOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130312120446.GA27461@S2101-09.ap.freescale.net>
References: <1363045833-6690-1-git-send-email-festevam@gmail.com>
	<20130312120446.GA27461@S2101-09.ap.freescale.net>
Date: Tue, 12 Mar 2013 20:14:05 +0800
Message-ID: <CAAQ0ZWQCf+M=37fntENag6CYsFvTZoNKZBAcgbA11s0=OPPH-A@mail.gmail.com>
Subject: Re: [PATCH] dma: mxs-dma: Convert to devm_ioremap_resource()
From: Shawn Guo <shawn.guo@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 March 2013 20:04, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Mon, Mar 11, 2013 at 08:50:33PM -0300, Fabio Estevam wrote:
>> Converting to devm_ioremap_resource() can make the code cleaner and smaller.
>>
> While you are there, you may want to use devm_kzalloc() and
> devm_clk_get() as well.
>
I even forgot to mention that I already had a patch [1] doing that.

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/106027/focus=220812
