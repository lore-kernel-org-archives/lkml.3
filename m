Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934791Ab3CZP1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:27:35 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57054 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932591Ab3CZP1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:27:33 -0400
Date: Tue, 26 Mar 2013 15:26:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCHv3 01/10] clocksource: add generic dummy timer driver
Message-ID: <20130326152635.GB17081@e106331-lin.cambridge.arm.com>
References: <1363198676-30417-1-git-send-email-sboyd@codeaurora.org>
 <1363198676-30417-2-git-send-email-sboyd@codeaurora.org>
 <20130321180922.GB10716@e106331-lin.cambridge.arm.com>
 <514B4DBD.4060403@codeaurora.org>
 <20130322180305.GB1436@e106331-lin.cambridge.arm.com>
 <5150800E.2000905@codeaurora.org>
 <20130325180007.GA4065@e106331-lin.cambridge.arm.com>
 <alpine.LFD.2.02.1303252147080.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1303252147080.22263@ionos>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 08:47:42PM +0000, Thomas Gleixner wrote:
> On Mon, 25 Mar 2013, Mark Rutland wrote:
> > Thomas, do you have an idea of if/when tip/timers/urgent will hit mainline?
> 
> Thanks for the reminder. I just sent a pull request Linuswards.

Cheers!

Mark.
