Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3F0HcC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:32:02 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:53312 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3F0HcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:32:00 -0400
Date: Thu, 27 Jun 2013 16:31:57 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH v2] clocksource: sh_cmt: Use devm_* managed helpers
Message-ID: <20130627073156.GA13927@verge.net.au>
References: <1371558978-10870-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <CANqRtoQUadXd+RGbW3S1S4vxvz+iQJVoAVXY-JL-2G-DJTT6WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoQUadXd+RGbW3S1S4vxvz+iQJVoAVXY-JL-2G-DJTT6WQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:29:38PM +0900, Magnus Damm wrote:
> On Tue, Jun 18, 2013 at 9:36 PM, Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > This simplifies the main error path by getting rid of it.
> >
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Looking good, thanks!
> 
> Acked-by: Magnus Damm <damm@opensource.se>

Thanks, queued up for v3.12 in the clocksource branch.
