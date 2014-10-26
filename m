Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbaJZKwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 06:52:11 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:35520 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaJZKwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 06:52:09 -0400
Message-ID: <544CD24B.2020505@acm.org>
Date: Sun, 26 Oct 2014 11:51:55 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Edward Thornber <thornber@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 0/18] SCSI XCOPY support for the kernel and
 device mapper
References: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1410220913280.31351@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/14 15:24, Mikulas Patocka wrote:
> I uploaded the new version of SCSI/device-mapper XCOPY patches here:
> http://people.redhat.com/~mpatocka/patches/kernel/xcopy/series.html
>
> I am also sending the patches in the following emails.

Hello Mikulas,

Which is the base commit of this patch series ? Patch 5/18 fails to 
apply on top of kernel v3.18-rc1 + patches 1..4.

Thanks,

Bart.

