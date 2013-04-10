Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937086Ab3DJQ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:29:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39043 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab3DJQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:29:28 -0400
Message-ID: <5165934B.6050802@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 12:28:59 -0400
From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Roland Dreier <roland@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
References: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3948.40205@linux.vnet.ibm.com> <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com> <515F42EE.8060203@linux.vnet.ibm.com> <20130409190350.GB8212@redhat.com> <5164BFE3.4040204@linux.vnet.ibm.com> <20130410032449.GA12777@redhat.com> <5164EB5F.80403@linux.vnet.ibm.com> <20130410053255.GC12777@redhat.com> <516589C8.1040606@linux.vnet.ibm.com> <20130410150539.GA24381@redhat.com>
In-Reply-To: <20130410150539.GA24381@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041016-3620-0000-0000-000001FA1F28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 11:05 AM, Michael S. Tsirkin wrote:
> On Wed, Apr 10, 2013 at 11:48:24AM -0400, Michael R. Hines wrote:
>> There's a very nice, simple client/server RDMA application on the
>> internet you can use to test your patch.
>>
>> http://thegeekinthecorner.wordpress.com/2010/09/28/
>> rdma-read-and-write-with-ib-verbs/
>>
>> This guy provides the source code which dumps several gigabytes over RDMA
>> to the other side.
>>
>> There's no need to run QEMU to test your patch,
>> assuming you have access to infiniband hardware.
>>
>> - Michael
>
> Does this app have any COW pages?

It can easily be made to be. It's just a couple of C source files.

I've only used it for basic testing.

