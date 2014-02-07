Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaBGWoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 17:44:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaBGWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 17:44:35 -0500
Date: Fri, 7 Feb 2014 14:45:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 72/73] drivers: delete remaining non-required instances
 of <linux/init.h>
Message-ID: <20140207224545.GA17133@kroah.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-73-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-73-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:23:15PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> This covers off all the remaining scattered instances in drivers
> in order to avoid a bunch more separate smaller commits.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
