Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbaIPWk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:40:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57425 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaIPWkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:40:25 -0400
Date: Tue, 16 Sep 2014 15:40:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ching Huang <ching2048@areca.com.tw>
Cc: Tomas Henzl <thenzl@redhat.com>, jbottomley@parallels.com,
        dan.carpenter@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
Message-ID: <20140916224019.GA7738@infradead.org>
References: <1408433122.4748.73.camel@Centos6.3-64>
 <53FDE490.1070201@redhat.com>
 <1409240809.4762.259.camel@Centos6.3-64>
 <53FF2544.8020601@redhat.com>
 <20140909163057.GA25745@infradead.org>
 <541020CB.8010302@redhat.com>
 <5416E858.7010709@redhat.com>
 <20140915170519.GB31009@infradead.org>
 <1410835328.4782.9.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410835328.4782.9.camel@Centos6.3-64>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 10:42:08AM +0800, Ching Huang wrote:
> The [PATCH v5 2/2] was depend on [PATCH v4 1/2].
> If you skip patch 1/2, then patch 2/2 may cause line number mismatch.
> How should I do? Please advise.

Hi Ching,

[PATCH v5 2/2] applied without a problem.  Please look at my
drivers-for-3.18 branch and send any additional patches relative to
that.
