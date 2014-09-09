Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbaIIQbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:31:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbaIIQbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:31:02 -0400
Date: Tue, 9 Sep 2014 09:30:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tomas Henzl <thenzl@redhat.com>
Cc: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org,
        jbottomley@parallels.com, dan.carpenter@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Message-ID: <20140909163057.GA25745@infradead.org>
References: <1408433122.4748.73.camel@Centos6.3-64>
 <53FDE490.1070201@redhat.com>
 <1409240809.4762.259.camel@Centos6.3-64>
 <53FF2544.8020601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF2544.8020601@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ching,

do you have a chance to address Thomas second concern below?  As
far as I can tell (Thomas, please correct me) that's the last
outstanding concern, and I'd really like to merge the arcmsr updates
for the Linux 3.18 merge window.

