Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaAMVLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 16:11:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52511 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaAMVL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 16:11:27 -0500
Date: Mon, 13 Jan 2014 13:12:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Len Brown <len.brown@intel.com>, athorlton@sgi.com, riel@redhat.com,
        chegu_vinod@hp.com, "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: Idle power fix regresses ebizzy performance (was 3.12-stable
 backport of NUMA balancing patches)
Message-ID: <20140113211204.GC17131@kroah.com>
References: <1389103248-17617-1-git-send-email-mgorman@suse.de>
 <20140107141715.GA32491@kroah.com>
 <20140107185440.GA7844@kroah.com>
 <20140107203012.GA27046@suse.de>
 <20140108104340.GC27046@suse.de>
 <20140108134858.GF27046@suse.de>
 <20140113192406.GL27046@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113192406.GL27046@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 07:24:06PM +0000, Mel Gorman wrote:
> On Wed, Jan 08, 2014 at 01:48:58PM +0000, Mel Gorman wrote:
> > Adding LKML to the list as this -stable snifftest has identified an
> > upstream regression.
> > 
> 
> This is a false alarm.

Thanks for tracking this down and letting us know.

greg k-h
