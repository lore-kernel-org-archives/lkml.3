Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3FRA41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 20:56:27 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5942 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab3FRA40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 20:56:26 -0400
Message-ID: <51BFB016.5010900@huawei.com>
Date: Tue, 18 Jun 2013 08:55:50 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <ptyser@xes-inc.com>, <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 10/24] drivers/mfd/lpc_ich: Convert to module_pci_driver
References: <1369621736-34664-1-git-send-email-libo.chen@huawei.com> <20130617233022.GX7998@zurbaran>
In-Reply-To: <20130617233022.GX7998@zurbaran>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/18 7:30, Samuel Ortiz wrote:
> Hi Libo,
> 
> 
> On Mon, May 27, 2013 at 10:28:56AM +0800, Libo Chen wrote:
>> use module_pci_driver instead of init/exit, make code clean.
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/mfd/lpc_ich.c |   13 +------------
>>  1 files changed, 1 insertions(+), 12 deletions(-)
> Patch applied, thanks.
> 

Hi Samuel,

This patch has beed merged to linux-next by Andrew Morton <akpm@linux-foundation.org>

Thanks,
Libo


> Cheers,
> Samuel.
> 


