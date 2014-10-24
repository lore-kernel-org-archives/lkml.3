Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaJXIL0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:11:26 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62256 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaJXILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:11:15 -0400
Date: Fri, 24 Oct 2014 09:11:10 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [STLinux Kernel] [PATCH 1/3] media: st-rc: move to using
 reset_control_get_optional
Message-ID: <20141024081110.GA22250@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411424546-12718-1-git-send-email-srinivas.kandagatla@linaro.org>
 <20140923180255.GA3430@griffinp-ThinkPad-X1-Carbon-2nd>
 <54227CD2.5020705@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54227CD2.5020705@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Srini,

Sorry seems I never replied to this.

> >>drivers/media/rc/st_rc.c:281:15: warning: assignment makes pointer
> >>from integer without a cast [enabled by default]
> >>   rc_dev->rstc = reset_control_get(dev, NULL);
> >
> >Is managing the reset line actually optional though? I can't test atm as I don't have
> >access to my board, but quite often if the IP's aren't taken out of reset reads / writes
> >to the perhpiheral will hang the SoC.
> >
> Yes and No.
> AFAIK reset line is optional on SOCs like 7108, 7141.
> I think having the driver function without reset might is a value
> add in case we plan to reuse the mainline driver for these SOCs.

Yes that is a good point, for the series: -

Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.
