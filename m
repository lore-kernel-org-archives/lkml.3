Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaJAVNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:13:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52662 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaJAVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:13:38 -0400
Date: Wed, 1 Oct 2014 14:13:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] wd719x: Introduce Western Digital WD7193/7197/7296
 PCI SCSI card driver
Message-ID: <20141001211337.GC24820@infradead.org>
References: <1411757808-12530-1-git-send-email-linux@rainbow-software.org>
 <20141001181907.GA668@infradead.org>
 <201410012222.14159.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201410012222.14159.linux@rainbow-software.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 10:22:13PM +0200, Ondrej Zary wrote:
> Maybe somewhere in Documentation?
> 
> Unfortunately, there is no single place to collect scripts like this.
> DVB has nice script at Documentation/dvb/get_dvb_firmware.
> But e.g. b43 requires an extrnal tool called b43-fwcutter.

Documentation/ or scripts/ is fine with me, as would be a comment in the
source file.  Just make sure people can find it easily.
