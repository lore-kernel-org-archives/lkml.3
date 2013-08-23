Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3HWVeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:34:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab3HWVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:34:20 -0400
Date: Fri, 23 Aug 2013 14:34:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] workqueue: convert bus code to use dev_groups
Message-ID: <20130823213419.GA13145@kroah.com>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
 <1377293081-10957-15-git-send-email-gregkh@linuxfoundation.org>
 <20130823212832.GC11391@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130823212832.GC11391@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:28:32PM -0400, Tejun Heo wrote:
> On Fri, Aug 23, 2013 at 02:24:41PM -0700, Greg Kroah-Hartman wrote:
> > The dev_attrs field of struct bus_type is going away soon, dev_groups
> > should be used instead.  This converts the workqueue bus code to use
> > the correct field.
> > 
> > Cc: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> If you want the patch to be routed through the wq tree, please let me
> know.

No worries, I can take this through my driver-core tree, thanks for the
ack.

greg k-h
