Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab3I0QRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 12:17:11 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:37129 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab3I0QRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 12:17:08 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Sep 2013 12:17:08 EDT
Date: Fri, 27 Sep 2013 18:08:51 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 04/27] mmc: cb710: Move away from using deprecated APIs
Message-ID: <20130927160851.GA14940@rere.qmqm.pl>
References: <1380207292-16968-1-git-send-email-ulf.hansson@linaro.org>
 <1380207292-16968-5-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380207292-16968-5-git-send-email-ulf.hansson@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 04:54:29PM +0200, Ulf Hansson wrote:
> Suspend and resume of cards are being handled from the protocol layer
> and consequently the mmc_suspend|resume_host APIs are deprecated.
> 
> This means we can simplify the suspend|resume callbacks by removing the
> use of the deprecated APIs.
> 
> Cc: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Patch looks consistent with commit message. I can't test it on HW, though.

Acked-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
