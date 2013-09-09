Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IINle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:41:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3IINlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:41:32 -0400
Date: Mon, 9 Sep 2013 06:41:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [scsi] enclosure: remove all possible sysfs entries
 before add device
Message-ID: <20130909134131.GB24738@infradead.org>
References: <522D685D.5060201@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522D685D.5060201@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Modules linked in: oracleacfs(P)(U) oracleadvm(P)(U) oracleoks(P)(U)

Please reproduce without this weird crap loaded.

