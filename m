Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935217Ab3DPStc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:49:32 -0400
Received: from sub0000499296.hmk-temp.com ([153.122.6.145]:41344 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3DPStb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:49:31 -0400
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Apr 2013 14:49:30 EDT
Date: Wed, 17 Apr 2013 03:42:03 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Simon Horman <horms@verge.net.au>, David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 19/26] sh: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130416184203.GA18348@linux-sh.org>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133009.32763.71122.stgit@warthog.procyon.org.uk>
 <20130416061113.GA27462@verge.net.au>
 <20130416062842.GL4068@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416062842.GL4068@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:28:42AM +0100, Al Viro wrote:
> On Tue, Apr 16, 2013 at 03:11:13PM +0900, Simon Horman wrote:
> > On Thu, Apr 11, 2013 at 02:30:09PM +0100, David Howells wrote:
> > > Don't use create_proc_read_entry() as that is deprecated, but rather use
> > > proc_create_data() and seq_file instead.
> > 
> > Paul, do you want me to handle this?
> 
> FWIW, I can pick that stuff via vfs.git - not a problem and I've already got
> shitloads of procfs-related patches in that queue...

That works for me.
