Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab3CYRlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:41:01 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:54154 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758802Ab3CYRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:40:58 -0400
Date: Mon, 25 Mar 2013 10:40:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/11] Qualcomm SSBI bus driver
Message-ID: <20130325174055.GA8204@kroah.com>
References: <1362616187-21089-1-git-send-email-davidb@codeaurora.org>
 <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363113716-25897-1-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 11:41:45AM -0700, David Brown wrote:
> This small series adds the Qualcomm SSBI bus driver.  The original
> driver was developed as part of Android.  Kenneth Heitke updated this,
> and sent it out a while back.  This series updates this driver to use
> DeviceTree, and fixes a few things that have changed since it was
> originally sent out.
> 
> In addition, the 11th patch, the RFC, is a small test driver that reads
> the version register off of the pm8058 device typically connected to
> an MSM8660 or MSM8960.  This is primarily useful to anyone wanting to
> work on these pmic drivers.
> 
> Updates to the PMIC drivers themselves to use this driver to come.

The first 10 now applied to my char/misc tree, thanks.

greg k-h
