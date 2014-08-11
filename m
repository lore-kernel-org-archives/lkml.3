Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaHKNIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:08:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35660 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaHKNIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:08:17 -0400
Date: Mon, 11 Aug 2014 16:07:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ching Huang <ching2048@areca.com.tw>
Cc: Tomas Henzl <thenzl@redhat.com>, hch@infradead.org,
        jbottomley@parallels.com, agordeev@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/17] arcmsr: Add code to support system hibernation
Message-ID: <20140811130731.GK11899@mwanda>
References: <1407499546.5099.8.camel@Centos6.3-64>
 <53E4DD71.4050203@redhat.com>
 <1407755395.4803.10.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407755395.4803.10.camel@Centos6.3-64>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 07:09:55PM +0800, Ching Huang wrote:
> Yes. 18/18 is obsolete.
> Thanks to Tomas's advice.
> 

There is no way to keep track of all the patches because they aren't
in an email thread.  Could you resend everything using git-format-patch
to send them as one thread?

regards,
dan carpenter

