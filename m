Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaEBIwH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 04:52:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:45347 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaEBIwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 04:52:03 -0400
Date: Fri, 2 May 2014 11:51:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: ching <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, thenzl@redhat.com, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1.0 10/16] arcmsr: clear outbound doorbell buffer
Message-ID: <20140502085148.GE4963@mwanda>
References: <1398856765.6930.41.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398856765.6930.41.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:19:25PM +0800, ching wrote:
> From: Ching<ching2048@areca.com.tw>
> 
> Clearing outbound doorbell buffer completely for adapter type C.
> 

What are the user visible effects of this bug?

regards,
dan carpenter

