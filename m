Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbaBSPWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:22:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772AbaBSPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:22:17 -0500
Date: Wed, 19 Feb 2014 07:24:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: sachin.kamat@linaro.org, swetland@google.com, devel@driverdev.osusl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: android: binder: convert commented messages to
 pr_debug
Message-ID: <20140219152450.GA6141@kroah.com>
References: <1392781773-1941-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392781773-1941-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 12:49:33PM +0900, SeongJae Park wrote:
> 2 debugging messages were just commented out for normal case. Let them
> be activated on debug mode without explicit code modification.

Are you sure this doesn't just always send the messages to the debug log
all the time now?  Again, I'd just leave it alone...

