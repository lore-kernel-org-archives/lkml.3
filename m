Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIJSOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 14:14:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38097 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaIJSOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 14:14:10 -0400
Message-ID: <54109506.70207@ti.com>
Date: Wed, 10 Sep 2014 14:14:30 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [RESEND: PATCH] ahci: add pcid for Marvel 0x9182 controller
References: <1409937660-30544-1-git-send-email-m-karicheri2@ti.com> <20140905175326.GB12991@mtj.dyndns.org>
In-Reply-To: <20140905175326.GB12991@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:53 PM, Tejun Heo wrote:
> On Fri, Sep 05, 2014 at 01:21:00PM -0400, Murali Karicheri wrote:
>> Keystone K2E EVM uses Marvel 0x9182 controller. This requires support
>> for the ID in the ahci driver.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>
> Applied to libata/for-3.17-fixes w/ stable cc'd.
>
> Thanks.
>
Tejun,

Thanks

Murali
