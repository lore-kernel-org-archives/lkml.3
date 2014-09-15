Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaIONYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:24:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaIONYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:24:07 -0400
Message-ID: <5416E858.7010709@redhat.com>
Date: Mon, 15 Sep 2014 15:23:36 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Ching Huang <ching2048@areca.com.tw>, jbottomley@parallels.com,
        dan.carpenter@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 16/17] arcmsr: support new adapter ARC12x4 series
References: <1408433122.4748.73.camel@Centos6.3-64> <53FDE490.1070201@redhat.com> <1409240809.4762.259.camel@Centos6.3-64> <53FF2544.8020601@redhat.com> <20140909163057.GA25745@infradead.org> <541020CB.8010302@redhat.com>
In-Reply-To: <541020CB.8010302@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 11:58 AM, Tomas Henzl wrote:
> On 09/09/2014 06:30 PM, Christoph Hellwig wrote:
>> Ching,
>>
>> do you have a chance to address Thomas second concern below?  As
>> far as I can tell (Thomas, please correct me) that's the last
>> outstanding concern, and I'd really like to merge the arcmsr updates
>> for the Linux 3.18 merge window.
> Correct, still awaiting a response.

Christoph,

you may add my 'reviewed-by' to the arcmsr series
http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
with the '[PATCH v5 2/2] arcmsr: simplify of updating doneq_index and postq_index'
( https://lkml.org/lkml/2014/9/15/177 ) on top of the series
that last patch fixes the 16/17 from your git.
I hope the series is an iteration in the right direction.
Skip the the '[PATCH v4 1/2] arcmsr: simplify ioctl data read/write', Ching will repost it later.

Tomas

>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

