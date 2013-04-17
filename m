Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3DQAlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:41:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:54598 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab3DQAlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:41:20 -0400
Date: Wed, 17 Apr 2013 09:41:15 +0900
From: Simon Horman <horms@verge.net.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 19/26] sh: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130417004115.GD16092@verge.net.au>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133009.32763.71122.stgit@warthog.procyon.org.uk>
 <20130416061113.GA27462@verge.net.au>
 <20130416062842.GL4068@ZenIV.linux.org.uk>
 <20130416184203.GA18348@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416184203.GA18348@linux-sh.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 03:42:03AM +0900, Paul Mundt wrote:
> On Tue, Apr 16, 2013 at 07:28:42AM +0100, Al Viro wrote:
> > On Tue, Apr 16, 2013 at 03:11:13PM +0900, Simon Horman wrote:
> > > On Thu, Apr 11, 2013 at 02:30:09PM +0100, David Howells wrote:
> > > > Don't use create_proc_read_entry() as that is deprecated, but rather use
> > > > proc_create_data() and seq_file instead.
> > > 
> > > Paul, do you want me to handle this?
> > 
> > FWIW, I can pick that stuff via vfs.git - not a problem and I've already got
> > shitloads of procfs-related patches in that queue...
> 
> That works for me.

Great.

Acked-by: Simon Horman <horms+renesas@verge.net.au>

