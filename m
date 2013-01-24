Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3AXSPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:15:40 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52999 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3AXSPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:15:39 -0500
Date: Thu, 24 Jan 2013 10:15:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Robin Holt <holt@sgi.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: How should I proceed to get commit 891348c to 3.0.y?
Message-ID: <20130124181535.GB12106@kroah.com>
References: <20130124152851.GF3460@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124152851.GF3460@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 09:28:51AM -0600, Robin Holt wrote:
> 
> I missed the email from 12/31 indicating commit 891348c was pulled from
> the 3.0.y stable tree due to a build breakage.
> 
> That commit requires the enum defined in traps.h by commit c940826.  That,
> in turn depends on commit 228bdaa95f which depends upon earlier commits.
> 
> How should I proceed?  Should I give you a patch that uses the constants
> in xpc_main.c? Should I add a patch which just pulls the enum portion of
> commit c940826 into traps.h? Any other direction you think this should go?

I think the last one makes the most sense as that makes it all
self-contained and sensible, right?

thanks,

greg k-h
