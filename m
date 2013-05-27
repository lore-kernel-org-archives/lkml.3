Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab3E0HmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 03:42:08 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:24055 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab3E0HmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 03:42:06 -0400
Message-ID: <51A30E37.9020701@huawei.com>
Date: Mon, 27 May 2013 15:41:43 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Libo Chen <libo.chen@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/24] drivers/scsi/initio: Convert to module_pci_driver
References: <1369621717-5860-1-git-send-email-libo.chen@huawei.com> <1369636713.1904.8.camel@dabdike>
In-Reply-To: <1369636713.1904.8.camel@dabdike>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/27 14:38, James Bottomley wrote:
> On Mon, 2013-05-27 at 10:28 +0800, Libo Chen wrote:
>> use module_pci_driver instead of init/exit, make code clean.
> 
> For the ancient drivers, like this, the principal is that we really
> don't touch except for tested bug fixes.  For the current ones (like
> mvumi) it's up to the maintainer.
> 
> James
Hi james,

Thank you for your explanation!


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


