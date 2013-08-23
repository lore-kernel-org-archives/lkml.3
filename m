Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3HWINv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 04:13:51 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:24176 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3HWINs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 04:13:48 -0400
Message-ID: <5217100E.6080506@huawei.com>
Date: Fri, 23 Aug 2013 15:32:30 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-fsdevel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <v9fs-developer@lists.sourceforge.net>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/2] fs: supply inode uid/gid setting interface
References: <1377226118-43756-1-git-send-email-rui.xiang@huawei.com> <20130823041010.GA12296@kroah.com>
In-Reply-To: <20130823041010.GA12296@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/23 12:10, Greg KH wrote:
> On Fri, Aug 23, 2013 at 10:48:36AM +0800, Rui Xiang wrote:
>> This patchset implements an accessor functions to set uid/gid
>> in inode struct. Just finish code clean up.
> 
> Why?
> 
It can introduce a new function to reduce some codes. 
 Just clean up. 


Thanks.

