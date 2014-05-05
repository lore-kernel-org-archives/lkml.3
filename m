Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaEEMKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:10:54 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49692 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbaEEMKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:10:53 -0400
Date: Mon, 5 May 2014 15:10:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: James Bottomley <jbottomley@parallels.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1.0 14/16] arcmsr: fix sparse checking error
Message-ID: <20140505121036.GO4963@mwanda>
References: <1398857906.6930.59.camel@localhost>
 <20140502091315.GG4963@mwanda>
 <CAKiknE-cJZpkpjMEPiX_cP4iC3e_b5huk2WJBvK2FpkKHecJoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiknE-cJZpkpjMEPiX_cP4iC3e_b5huk2WJBvK2FpkKHecJoQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:10:39PM +0800, 黃清隆 wrote:
> Hi Dan,
> 
> In this patch, there are several replace of call readl() or writel()
> by direct access to memory.
> Because in main memory, we allocated a block of memory for
> post_qbuffer and done_qbuffer.
> These memory are access by both of CPU and IOP, they are not hardware registers.
> This change will not introduce a bug. I have verified it.
> 

Oh yeah.  I see that now.  I got mixed up.

regards,
dan carpenter

