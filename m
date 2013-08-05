Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458Ab3HEDLQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:11:16 -0400
Received: from ozlabs.org ([203.10.76.45]:53148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3HEDLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:11:14 -0400
Date: Mon, 5 Aug 2013 13:11:12 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: linux-mm <linux-mm@kvack.org>, isimatu.yasuaki@jp.fujitsu.com,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/8] Mark powerpc memory resources as busy
Message-ID: <20130805031111.GA5347@concordia>
References: <51F01E06.6090800@linux.vnet.ibm.com>
 <51F01EB2.9060802@linux.vnet.ibm.com>
 <20130802022827.GB1680@concordia>
 <51FC0315.1010601@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FC0315.1010601@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 02:05:57PM -0500, Nathan Fontenot wrote:
> On 08/01/2013 09:28 PM, Michael Ellerman wrote:
> > On Wed, Jul 24, 2013 at 01:36:34PM -0500, Nathan Fontenot wrote:
> >> Memory I/O resources need to be marked as busy or else we cannot remove
> >> them when doing memory hot remove.
> > 
> > I would have thought it was the opposite?
> 
> Me too.
> 
> As it turns out the code in kernel/resource.c checks to make sure the
> IORESOURCE_BUSY flag is set when trying to release a resource.

OK, I guess there's probably some sane reason, but it does seem
backward.

cheers
