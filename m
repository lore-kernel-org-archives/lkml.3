Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbaKMO3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 09:29:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37154 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaKMO3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:29:14 -0500
Date: Thu, 13 Nov 2014 06:29:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Barto <mister.freeman@laposte.net>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Message-ID: <20141113142907.GB29354@infradead.org>
References: <54629CAE.2000207@laposte.net>
 <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
 <5462CB90.1080303@roeck-us.net>
 <54642541.9080302@laposte.net>
 <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
 <54647C10.4070506@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54647C10.4070506@laposte.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenters commit just fixes the inversion from commit

71e75c97f97a9645d25fbf3d8e4165a558f18747 scsi: convert device_busy to atomic_t

Can you please test the commit before that:
74665016086615bbaa3fa6f83af410a0a4e029ee scsi: convert host_busy to atomic_t

and check if that works for you or not.
