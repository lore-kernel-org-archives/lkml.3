Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622Ab3EBOIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:08:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab3EBOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:08:09 -0400
Date: Thu, 2 May 2013 16:07:53 +0200
From: Jens Axboe <axboe@kernel.dk>
To: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, klebers@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com
Subject: Re: [PATCH 1/8] rsxx: Adding in debugfs entries.
Message-ID: <20130502140753.GS7800@kernel.dk>
References: <20130502002317.GA29619@oc6784271780.ibm.com>
 <20130502080325.GF7800@kernel.dk>
 <20130502140444.GA10306@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502140444.GA10306@oc6784271780.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02 2013, Philip J. Kelleher wrote:
> On Thu, May 02, 2013 at 10:03:25AM +0200, Jens Axboe wrote:
> > On Wed, May 01 2013, Philip J. Kelleher wrote:
> > >  #define NO_LEGACY 0
> > > +#define DEBUGFS_NULL NULL
> > >  
> > > +static struct dentry *rsxx_debugfs_root = DEBUGFS_NULL;
> > 
> > What's the point of DEBUGFS_NULL?
> 
> Well, orginally, I had rsxx_debugfs_root initialized to NULL but
> the checkpatch script told me not to initialize directly with 0
> or NULL. So my solution is the #define macro.

Well, it's a static variable. The reason checkpatch tells you not to
initialize it to NULL/0 is because the bss is automatically zeroed.

-- 
Jens Axboe

