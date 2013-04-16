Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab3DPG2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 02:28:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60874 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab3DPG2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 02:28:48 -0400
Date: Tue, 16 Apr 2013 07:28:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Simon Horman <horms@verge.net.au>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 19/26] sh: Don't use create_proc_read_entry() [RFC]
Message-ID: <20130416062842.GL4068@ZenIV.linux.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <20130411133009.32763.71122.stgit@warthog.procyon.org.uk>
 <20130416061113.GA27462@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416061113.GA27462@verge.net.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 03:11:13PM +0900, Simon Horman wrote:
> On Thu, Apr 11, 2013 at 02:30:09PM +0100, David Howells wrote:
> > Don't use create_proc_read_entry() as that is deprecated, but rather use
> > proc_create_data() and seq_file instead.
> 
> Paul, do you want me to handle this?

FWIW, I can pick that stuff via vfs.git - not a problem and I've already got
shitloads of procfs-related patches in that queue...
