Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3HAIps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:45:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3HAIpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:45:45 -0400
Date: Thu, 1 Aug 2013 01:45:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Peng Tao <bergwolf@gmail.com>, Paul Bolle <pebolle@tiscali.nl>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] staging/lustre: lloop depends on BLOCK
Message-ID: <20130801084539.GA13306@infradead.org>
References: <alpine.DEB.2.02.1307300827010.2625@M2420>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307300827010.2625@M2420>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 08:29:51AM +0800, Xiong Zhou wrote:
> From: Xiong Zhou <jencce.kernel@gmail.com>
> 
> In the lustre client driver, lloop depends on BLOCK. Add an
> option for this dependence. Last version of this patch makes
> LUSTRE_FS depends on BLOCK.
> Remove unnecessary jdb head files which depends on BLOCK.

The driver should be removed, a filesystem has no business bringing
its own loop driver.

