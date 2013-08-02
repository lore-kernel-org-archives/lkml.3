Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3HBC1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:27:11 -0400
Received: from ozlabs.org ([203.10.76.45]:53310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3HBC1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:27:09 -0400
Date: Fri, 2 Aug 2013 12:27:03 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 1/8] register bootmem pages for powerpc when sparse
 vmemmap is not defined
Message-ID: <20130802022703.GA1680@concordia>
References: <51F01E06.6090800@linux.vnet.ibm.com>
 <51F01E5F.80307@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F01E5F.80307@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:35:11PM -0500, Nathan Fontenot wrote:
> Previous commit 46723bfa540... introduced a new config option
> HAVE_BOOTMEM_INFO_NODE that ended up breaking memory hot-remove for powerpc
> when sparse vmemmap is not defined.

So that's a bug fix that should go into 3.10 stable?

cheers
