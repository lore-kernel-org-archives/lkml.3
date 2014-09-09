Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaIIUEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 16:04:22 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:56152 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbaIIUEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 16:04:01 -0400
Date: Tue, 9 Sep 2014 14:03:44 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Scot Doyle <lkml14@scotdoyle.com>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix interrupt timeouts
Message-ID: <20140909200344.GB14765@obsidianresearch.com>
References: <alpine.LNX.2.11.1408250710470.1443@localhost.localdomain>
 <201409092144.35387.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409092144.35387.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 09:44:35PM +0200, Peter Hüwe wrote:
> Hi Scot,
> Am Montag, 25. August 2014, 09:14:03 schrieb Scot Doyle:
> > commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
> >     wait: fix false timeouts when using wait_event_timeout()
> > 
> > changed the semantics of wait_event_interruptible_timeout so that a
> > condition check is performed after timeout and 1 is returned if true.
> 
> is this one still valid or superseeded by one of the other patches?

It is not correct, so NAK on this patch.

Jason
