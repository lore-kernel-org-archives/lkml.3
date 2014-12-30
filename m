Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaL3Pu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:50:59 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53649 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaL3Pu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:50:58 -0500
Date: Tue, 30 Dec 2014 07:50:57 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: status of ia64 / hpsim
Message-ID: <20141230155057.GA23826@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS the ia64 hpsim architecture still in use?  I noticed it because it
has a fairly rudimentary SCSI driver under arch/ia64, which doesn't
look very maintained.
