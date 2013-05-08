Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3EHPhm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:37:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35878 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab3EHPhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:37:42 -0400
Date: Wed, 8 May 2013 08:37:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        john.stultz@linaro.org, kernel-team@android.com, nnk@google.com
Subject: Re: [PATCH] staging: android: logger: use kuid_t instead of uid_t
Message-ID: <20130508153740.GB17186@kroah.com>
References: <alpine.DEB.2.02.1305081846070.29540@M2420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1305081846070.29540@M2420>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 06:52:48PM +0800, Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> Use kuid_t instead of uid_t, to pass the UIDGID_STRICT_TYPE_CHECKS.
> 
> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>

Nice job, I'll queue this up after 3.10-rc1 is out.

greg k-h
