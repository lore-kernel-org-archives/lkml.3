Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbaGAPDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:03:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37672 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaGAPDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:03:07 -0400
Date: Tue, 1 Jul 2014 11:02:59 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: PATCH 0/2 tmon: fix a few minor security issues
Message-ID: <20140701150259.GI7322@hmsreliant.think-freely.org>
References: <1403035509-31815-1-git-send-email-nhorman@tuxdriver.com>
 <20140701114249.GF7322@hmsreliant.think-freely.org>
 <1404222565.8366.32.camel@rzhang1-toshiba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404222565.8366.32.camel@rzhang1-toshiba>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 09:49:25PM +0800, Zhang Rui wrote:
> On Tue, 2014-07-01 at 07:42 -0400, Neil Horman wrote:
> > On Tue, Jun 17, 2014 at 04:05:07PM -0400, Neil Horman wrote:
> > > Just a few little fixups for tmon, to prevent abuse of its logging facility
> > > 
> > > Best
> > > Neil
> > > 
> > Ping, Zhang, Jacob acked these, but I've not seen them go into your tree yet.
> > Do you have an issue with them?
> > 
> Oh, next time when you send thermal related patches, please send them to
> linux-pm@vger.kernel.org mailing list so that I can review the patches
> in https://patchwork.kernel.org/project/linux-pm/list/
> 
> Both patches applied. Thanks!
> 
Will do, thanks!
Nei

> -rui
> > Neil
> > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > > 
> 
> 
> 
