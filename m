Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaHEUR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 16:17:28 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:46183 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbaHEUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 16:17:26 -0400
From: Lina Iyer <lina.iyer@linaro.org>
X-Google-Original-From: Lina Iyer <Lina@linaro.org>
Date: Tue, 5 Aug 2014 14:17:23 -0600 (MDT)
X-X-Sender: Lina@ilina-mac
To: Bjorn Andersson <bjorn@kryo.se>
cc: Lina Iyer <lina.iyer@linaro.org>, Stephen Boyd <sboyd@codeaurora.org>,
        David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 8/8] msm: scm: Move the scm driver to drivers/soc/qcom
In-Reply-To: <CAJAp7OiXW1A-H4io2kST_Y6LdVP+EYkXoU3GaWTRt_+CyXruQA@mail.gmail.com>
Message-ID: <alpine.OSX.2.03.1408051415360.89254@linaro.org>
References: <1407202310-3359-1-git-send-email-sboyd@codeaurora.org> <1407202310-3359-9-git-send-email-sboyd@codeaurora.org> <alpine.OSX.2.03.1408042203100.87047@linaro.org> <CAJAp7OiXW1A-H4io2kST_Y6LdVP+EYkXoU3GaWTRt_+CyXruQA@mail.gmail.com>
User-Agent: Alpine 2.03 (OSX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 5 Aug 2014, Bjorn Andersson wrote:

> On Mon, Aug 4, 2014 at 9:07 PM, Lina Iyer <lina.iyer@linaro.org> wrote:
> > On Mon, 4 Aug 2014, Stephen Boyd wrote:
> [...]
> > Could we move scm-boot.c as well to drivers/soc/qcom and scm-boot.h to include/soc/qcom ?
> 
> Yes, we can do that.
> 
> But as of now we seem to only have one caller of this wrapper, so
> maybe we could move the functionality into platsmp.c and drop the file
> instead?
I am working on cpuidle drivers for QCOM targets and would very much
like the scm-boot to be accessible from drivers/soc/qcom.

