Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3KOVTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:19:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36092 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KOVTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:19:16 -0500
Date: Sat, 16 Nov 2013 06:19:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@rjwysocki.net,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH] power: Replace printks with pr_* routines
Message-ID: <20131115211922.GB14410@kroah.com>
References: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:10:06AM -0700, Shuah Khan wrote:
> Replaced printks with pr_* routines. dev_* routines could have been used,
> but chose to use pr_* to avoid breaking scripts that might be relying on
> a specific text.

I'd really like to switch to dev_* instead, even changing to pr_* should
change the output prefix (if it's set for this file, odds are it isn't
though...)

thanks,

greg k-h
