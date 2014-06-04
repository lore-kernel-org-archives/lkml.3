Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238AbaFDPKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:10:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaFDPKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:10:16 -0400
Date: Wed, 4 Jun 2014 08:10:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Adithya.K" <linux.challenge1@gmail.com>
Cc: omar.ramirez@copitl.com, rashika.kheria@gmail.com, freemangordon@abv.bg,
        dan.carpenter@oracle.com, ody.guru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging:tidspbridge Fix minor checkpatch.pl warning.
Message-ID: <20140604151012.GA2218@kroah.com>
References: <y>
 <1401893916-23366-1-git-send-email-linux.challenge1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401893916-23366-1-git-send-email-linux.challenge1@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:28:36PM +0530, Adithya.K wrote:
> From: Adithya K <linux.challenge1@gmail.com>
> 
> Fixed few checkpatch.pl warnings.

Be specific about _what_ warnings you fixed.  And if you fix more than
one type of warning, please break it up into different patches (each
patch only can do one thing.)

> Signed-off-by: Adithya K <linux.challenge1@gmail.com>

I need a "full" name for a kernel patch.  I have to ask, is your last
name really just one letter?

thanks,

greg k-h
