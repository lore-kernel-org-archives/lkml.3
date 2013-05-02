Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759518Ab3EBOFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:05:23 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51056 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab3EBOFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:05:22 -0400
Date: Thu, 2 May 2013 09:04:44 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 1/8] rsxx: Adding in debugfs entries.
Message-ID: <20130502140444.GA10306@oc6784271780.ibm.com>
References: <20130502002317.GA29619@oc6784271780.ibm.com>
 <20130502080325.GF7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502080325.GF7800@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050214-9360-0000-0000-000011FFCD0A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 10:03:25AM +0200, Jens Axboe wrote:
> On Wed, May 01 2013, Philip J. Kelleher wrote:
> >  #define NO_LEGACY 0
> > +#define DEBUGFS_NULL NULL
> >  
> > +static struct dentry *rsxx_debugfs_root = DEBUGFS_NULL;
> 
> What's the point of DEBUGFS_NULL?

Well, orginally, I had rsxx_debugfs_root initialized to NULL but
the checkpatch script told me not to initialize directly with 0
or NULL. So my solution is the #define macro.

> 
> -- 
> Jens Axboe
> 


Thanks
-Philip Kelleher

