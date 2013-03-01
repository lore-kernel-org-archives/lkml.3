Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3CADyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:54:21 -0500
Received: from ozlabs.org ([203.10.76.45]:35615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179Ab3CADyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:54:20 -0500
Date: Fri, 1 Mar 2013 14:54:17 +1100
From: Michael Ellerman <michael@ellerman.id.au>
To: Mike <qiudayu@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Enable multiple MSI feature in pSeries
Message-ID: <20130301035417.GA17236@concordia>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
 <1362107325.2712.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362107325.2712.2.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 11:08:45AM +0800, Mike wrote:
> Hi all
> 
> Any comments? or any questions about my patchset?

You were going to get some performance numbers that show a definite
benefit for using more than one MSI.

cheers
