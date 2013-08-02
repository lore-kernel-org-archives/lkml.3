Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab3HBCdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:33:05 -0400
Received: from ozlabs.org ([203.10.76.45]:52928 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3HBCdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:33:03 -0400
Date: Fri, 2 Aug 2013 12:32:59 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 3/8] Add all memory via sysfs probe interface at once
Message-ID: <20130802023259.GC1680@concordia>
References: <51F01E06.6090800@linux.vnet.ibm.com>
 <51F01EFB.6070207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F01EFB.6070207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:37:47PM -0500, Nathan Fontenot wrote:
> When doing memory hot add via the 'probe' interface in sysfs we do not
> need to loop through and add memory one section at a time. I think this
> was originally done for powerpc, but is not needed. This patch removes
> the loop and just calls add_memory for all of the memory to be added.

Looks like memory hot add is supported on ia64, x86, sh, powerpc and
s390. Have you tested on any?
 
cheers
