Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbaAJPqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:46:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47537 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757202AbaAJPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:46:11 -0500
Date: Fri, 10 Jan 2014 10:46:10 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: gregkh@linuxfoundation.org, <linux-kernel@vger.kernel.org>,
        <schwidefsky@de.ibm.com>, <heiko.carstens@de.ibm.com>,
        <JBottomley@parallels.com>, <bhelgaas@google.com>
Subject: Re: [PATCHSET v2 driver-core-next] kernfs, sysfs, driver-core:
 implement synchronous self-removal
In-Reply-To: <20140110135416.GA8752@htj.dyndns.org>
Message-ID: <Pine.LNX.4.44L0.1401101042010.1399-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jan 2014, Tejun Heo wrote:

> On Fri, Jan 10, 2014 at 08:46:46AM -0500, Tejun Heo wrote:
> > Hello,
> > 
> > This is the second take of kernfs self-removal patchset.  Changes from
> > the last take[L] are,
> 
> Ugh... I'm hating myself.  These are slightly stale patches.  I got
> confused between two trees.  Please ignore this thread.  I'll post v3
> right away.
> 
> Sorry about the trouble.

Tejun,

The SUBJECT lines in your patch emails don't mention the version
number.  That is, they just say "[PATCH]", not "[PATCH v2]" or "[PATCH
v3]". This makes it very difficult for me to tell which messages to
read.

(Reading them in order doesn't work, because my computer mixes up the 
order of messages when it downloads a large bunch from the email 
server.  It's kind of annoying...)

Alan Stern

