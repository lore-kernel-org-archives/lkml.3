Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761031AbaGPD3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:29:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760995AbaGPD3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:29:09 -0400
Date: Tue, 15 Jul 2014 20:33:42 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Suman Tatiraju <sumant@codeaurora.org>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] PM / devfreq: Allocate memory using the right data type
Message-ID: <20140716033342.GA31052@kroah.com>
References: <1405480243-25915-1-git-send-email-skannan@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405480243-25915-1-git-send-email-skannan@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 08:10:43PM -0700, Saravana Kannan wrote:
> From: Suman Tatiraju <sumant@codeaurora.org>
> 
> Long and int have different sizes on a 64-bit machine. Allocate
> memory for the time_in_state table using the right data type.
> 
> Change-Id: I335277674018c0ea759aa0996309d52578ea1fd5

Please don't put this crud in patches you submit upstream.  It means
nothing to us.

> Signed-off-by: Suman Tatiraju <sumant@codeaurora.org>
> Reviewed-by: Saravana Kannan <skannan@codeaurora.org>
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>  drivers/devfreq/devfreq.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
