Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3AOVmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:42:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44719 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab3AOVmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:42:10 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Shawn Guo <shawn.guo@linaro.org>, Fabio Estevam <festevam@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20130109055017.GA12525@S2100-06.ap.freescale.net>
Cc: <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
References: <1357609135-13922-1-git-send-email-festevam@gmail.com>
 <20130109055017.GA12525@S2100-06.ap.freescale.net>
Message-ID: <20130115214203.23734.17138@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: mxs: Index is always positive
Date: Tue, 15 Jan 2013 13:42:03 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Shawn Guo (2013-01-08 21:50:19)
> On Mon, Jan 07, 2013 at 11:38:55PM -0200, Fabio Estevam wrote:
> > From: Fabio Estevam <fabio.estevam@freescale.com>
> > 
> > Fix the following warnings when building with W=1 option:
> > 
> > drivers/clk/mxs/clk-imx23.c: In function 'mx23_clocks_init':
> > drivers/clk/mxs/clk-imx23.c:149:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> > drivers/clk/mxs/clk-imx23.c:165:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> > ...
> > 
> > drivers/clk/mxs/clk-imx28.c: In function 'mx28_clocks_init':
> > drivers/clk/mxs/clk-imx28.c:227:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> > drivers/clk/mxs/clk-imx28.c:244:16: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>

Pulled into clk-next.

Thanks,
Mike
