Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbaGPDW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:22:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46993 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759283AbaGPDWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:22:24 -0400
X-Sasl-enc: dqDlvfeSTcWyzFZwLjlWahPYbWyZQ2bTeU1Nx32FFCbE 1405480942
Date: Tue, 15 Jul 2014 20:26:55 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: char interface to sdio, chdio.c
Message-ID: <20140716032655.GB30412@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen.

I had some people ask me about a sdio userspace interface, and ran
across the chdio.c file as found in the MSM android kernel trees:

https://android.googlesource.com/kernel/msm/+/57b74303d6f033ab04be039379f6661337fb9279

Any reason why this hasn't been submitted upstream?  Or has it, and was
it rejected?

Also, what userspace code uses this?  Is there some android-specific
code somewhere that does a weird mix of sysfs and char control of the
hardware?  And what type of SDIO devices are controlled with this?

thanks,

greg k-h
