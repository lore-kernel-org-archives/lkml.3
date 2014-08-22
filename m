Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaHVQFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:05:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaHVQFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:05:19 -0400
Message-ID: <53F76A1F.1070609@redhat.com>
Date: Fri, 22 Aug 2014 18:04:47 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Ching Huang <ching2048@areca.com.tw>
CC: jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/17] arcmsr: change note since v13 or v2
References: <1408422598.4801.112.camel@Centos6.3-64> <20140819150221.GA4083@infradead.org>
In-Reply-To: <20140819150221.GA4083@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2014 05:02 PM, Christoph Hellwig wrote:
> Hi Ching,
>
> I've fixed up various checkpatch errors and fixed up some descriptions
> and applied the patches to a branch.  This includes patch 4, so please
> send a fix for this and any other patches relative to the branch.
>
> Please find the branch at
>
> 	git://git.infradead.org/users/hch/scsi-queue.git arcmsr-for-3.18
>
> Can the others help reviewing these patches and make sure we can get
> them into 3.18?

You may add my reviewed-by line to patches 1-12.
For the '[PATCH v3 13/17] arcmsr: fix ioctl data read/write error for adapter type C'
I have asked a question. I'll continue, when this is answered.

Tomas

>
> Thanks,
> 	Christoph
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

