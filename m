Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbaE3P5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:57:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60921 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE3P5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:57:44 -0400
Date: Fri, 30 May 2014 09:01:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Oliveira <cmroliv@gmail.com>
Cc: gulsah.1004@gmail.com, pavel@ucw.cz, pali.rohar@gmail.com,
        peter.p.waskiewicz.jr@intel.com, kristina.martsenko@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nokia_h4: nokia_core.c: use usleep_range()
 instead of msleep()
Message-ID: <20140530160121.GB10682@kroah.com>
References: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401445633-5290-1-git-send-email-cmroliv@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:27:13AM +0100, Miguel Oliveira wrote:
> Creating this patch for the Eudyptula Challenge.
> Replaced msleep() for a delay < 20ms with a usleep_range() between 10000us and 15000us.
> Also inserted a blank line after adeclaration.

As you are doing 2 different things in one patch, please break this up
into two different patches.  Remember, each patch can only do 1 thing.

That also lets us argue about the msleep() change, while I take your
whitespace fix :)

thanks,

greg k-h
