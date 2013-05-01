Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355Ab3EAOjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:39:05 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38110 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab3EAOi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:38:56 -0400
Date: Wed, 1 May 2013 09:38:50 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 1/9] rsxx: Adding in sysfs entries.
Message-ID: <20130501143850.GA7376@oc6784271780.ibm.com>
References: <20130430194855.GA22764@oc6784271780.ibm.com>
 <20130501123308.GB7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130501123308.GB7800@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050114-7182-0000-0000-0000067CF3EB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt reply.

I'll be honest, I was unaware of a debugfs. That should
be easy enough to incorporate.

Thanks,
-Philip Kelleher


On Wed, May 01, 2013 at 02:33:08PM +0200, Jens Axboe wrote:
> On Tue, Apr 30 2013, Philip J. Kelleher wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> > 
> > Adding in some sysfs entries to help with debugging and
> > testing code.
> 
> Should be in debugfs...
> 
> -- 
> Jens Axboe
> 

