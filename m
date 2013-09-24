Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab3IXNkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 09:40:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3IXNkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 09:40:16 -0400
Date: Tue, 24 Sep 2013 06:41:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Simon Horman <horms@verge.net.au>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
Message-ID: <20130924134113.GA7246@kroah.com>
References: <52410F86.4040301@renesas.com>
 <20130924131039.3c871cad7acb2a068a988d0f@ops.dti.ne.jp>
 <20130924044432.GD3619@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924044432.GD3619@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 01:44:32PM +0900, Simon Horman wrote:
> [ CCed Greg Kroah-Hartman, the serial maintainer for his review ]
> 
> On Tue, Sep 24, 2013 at 01:10:39PM +0900, takasi-y@ops.dti.ne.jp wrote:
> > From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > 
> > Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> > migrate to the common clock framework.
> > 
> > Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > [takashi.yoshii.ze@renesas.com: edited for conflicts]
> > Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

