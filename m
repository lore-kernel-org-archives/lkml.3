Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaEYWhV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 18:37:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEYWhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 18:37:20 -0400
Date: Sun, 25 May 2014 15:37:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masaru Nomura <massa.nomura@gmail.com>
Cc: andreas.dilger@intel.com, green@linuxhacker.ru, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: lustre: lnet: klnds: Fix coding style in
 socklnd.c
Message-ID: <20140525223719.GA24682@kroah.com>
References: <1401056652-596-1-git-send-email-massa.nomura@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401056652-596-1-git-send-email-massa.nomura@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2014 at 11:24:12PM +0100, Masaru Nomura wrote:
> Remove prohibited space between function name and
> open parenthesis to meet kernel coding style.
> Also fix indenting due to changes to keep readability.
> 
> -since v2:
> None. This is the resend of v2 as v2 failed to apply

This should be below the --- line.

And it still doesn't apply :(

What branch did you make it against?

greg k-h
