Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbaDERRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 13:17:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaDERRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 13:17:36 -0400
Date: Sat, 5 Apr 2014 10:20:00 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vincent <vincent.stehle@laposte.net>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH] topology: Fix compilation warning when not in SMP
Message-ID: <20140405172000.GB3850@kroah.com>
References: <1396593798-29173-1-git-send-email-vincent.stehle@laposte.net>
 <20140404234943.GA14633@kroah.com>
 <533FF763.3020000@bergerie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533FF763.3020000@bergerie>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 02:30:27PM +0200, Vincent wrote:
> On 04/05/2014 01:49 AM, Greg Kroah-Hartman wrote:
> > Warnings aren't a stable kernel issue, so why would this be relevant
> > there?
> 
> Oh, sorry about that. I'll go re-read the stable kernel rules again.
> 
> Shall I re-post without the stable Cc:, for only mainline and next?

No need, I'll just remove them when I apply the patch.

thanks,

greg k-h
