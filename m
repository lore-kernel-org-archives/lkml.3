Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbaIRS5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 14:57:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:32787 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaIRS5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:57:48 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org
References: <1371437905-15567-1-git-send-email-mturquette@linaro.org>
 <loom.20140815T164836-200@post.gmane.org>
In-Reply-To: <loom.20140815T164836-200@post.gmane.org>
Message-ID: <20140918185727.19023.24705@quantum>
Subject: Re: [PATCH v2 0/5] clk: dt: bindings for mux, divider & gate clocks
Date: Thu, 18 Sep 2014 11:57:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Florian Fainelli (2014-08-15 07:55:11)
> Mike Turquette <mturquette <at> linaro.org> writes:
> > 
> > Testing was done on OMAP4460 Panda ES using the experimental out-of-tree
> > OMAP CCF conversion patches posted recently.
> > 
> > Heiko, enough changed here such that I did not keep your Acked-by's and
> > Tested-by's. But I am happy to take them again 
> 
> It seems like Heiko provided some feedback, but I have not found v3 of the
> patches nor a reply to him. Do you plan on resubmitting these patches, I
> find them particularly helpful for some platform I am working on.

Hi Florian,

These patches were shouted down due to their bit-level properties in DT.
Also these old bindings support the one-clock-per-node style of bindings
which have been supplanted by the "clock controller" style binding.

Regards,
Mike

> 
> Thank you!
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
