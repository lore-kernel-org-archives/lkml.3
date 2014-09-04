Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaIDHYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:24:33 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:16802 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaIDHYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:24:32 -0400
Message-ID: <540813A5.7020704@huawei.com>
Date: Thu, 4 Sep 2014 15:24:21 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
References: <20140826230858.GA29970@kroah.com> <20140827045938.GA28282@roeck-us.net>
In-Reply-To: <20140827045938.GA28282@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Sorry for my late reply.

On 2014/8/27 12:59, Guenter Roeck wrote:
> On Tue, Aug 26, 2014 at 04:08:58PM -0700, Greg KH wrote:
>> Li has agreed to continue to support the 3.4 stable kernel tree until
>> September 2016.  Update the releases.html page on kernel.org to reflect
>> this.
>>
> Li,
> 
> it would be great if you can send me information about your -stable queue,
> ie how you maintain it and where it is located. This will enable me to
> continue testing the stable queue for the 3.4 kernel.
> 

Thanks for testing LTS kernels!

This is my 3.4.y git tree:

https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y.git/

And this is the patch queue:

https://git.kernel.org/cgit/linux/kernel/git/lizf/linux-3.4.y-queue.git/

I use quilt. When I've added some patches to 3.4.y, I'll update this
queue. The patches and series file are under /patches. Currently there's
already a patch in the queue.

When I release a new version, I'll clean up the queue by removing all
the files under /patches.

Hope this is all the information you need. Please tell me if you need
me to slightly adjust my workflow so it's easier for you.

