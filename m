Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab3FFP0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:26:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3FFP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:26:13 -0400
Date: Thu, 6 Jun 2013 08:26:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix null pointer dereference caused by sysfs_notify on
 binary attribute
Message-ID: <20130606152612.GA7495@kroah.com>
References: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370511920-8628-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 10:45:20AM +0100, Nick Dyer wrote:
> It would be nice to have this work as expected but for now this is a minimal
> fix to prevent the kernel panic.

Is anyone calling sysfs_notify on a binary attribute today?  Or can this
go into 3.11?

thanks,

greg k-h
