Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaL3MwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 07:52:03 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:59179 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaL3MwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 07:52:01 -0500
Date: Tue, 30 Dec 2014 04:52:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Adam Radford <linuxraid@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: 3w-9xxx.c:  Cleaning up missing null-terminate in
 conjunction with strncpy
Message-ID: <20141230125200.GA21852@infradead.org>
References: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406473878-12715-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied to scsi-for-3.20.
