Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbaLBSJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:09:53 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33768 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbaLBSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:09:51 -0500
X-Sasl-enc: 26jHWZ+FpKaMyxGCTyA+rmFXv9cbDesdf1ADkt7HbjE/ 1417543790
Date: Tue, 2 Dec 2014 10:09:49 -0800
From: Greg KH <greg@kroah.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the driver-core tree
Message-ID: <20141202180949.GA11700@kroah.com>
References: <20141201184205.08a8f7aa@canb.auug.org.au>
 <547C1C89.1070604@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547C1C89.1070604@broadcom.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 08:45:13AM +0100, Arend van Spriel wrote:
> On 01-12-14 08:42, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the driver-core tree, today's linux-next build (arm
> > multi_v7_defconfig) produced this warning:
> > 
> > In file included from kernel/power/main.c:16:0:
> > include/linux/debugfs.h:105:10: warning: 'struct device' declared inside parameter list
> >           void *data));
> >           ^
> > 
> > And many more like this.
> > 
> > Introduced by commit 98210b7f73f1 ("debugfs: add helper function to
> > create device related seq_file").  See Rule 1 from
> > Documentation/SubmitChecklist - though in this case a simple "struct
> > device;" would probably do.
> > 
> 
> I submitted a patch for that yesterday [1] and got (automated) email
> from Greg that it is going into his driver-core tree.
> 
> Regards,
> Arend
> 
> [1] http://mid.gmane.org/1417361481-1136-1-git-send-email-arend@broadcom.com

Sorry for the delay, is now in my driver-core-next branch, so this will
be fixed in the next linux-next pull.

greg k-h
