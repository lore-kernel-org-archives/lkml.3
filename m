Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaFKJNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:13:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7245 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaFKJNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:13:35 -0400
Message-ID: <53981D81.5060708@huawei.com>
Date: Wed, 11 Jun 2014 17:12:33 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <laijs@cn.fujitsu.com>,
        <sjenning@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Wang Nan <wangnan0@huawei.com>
Subject: Proposal to realize hot-add *several sections one time*
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now we can hot-add memory by

% echo start_address_of_new_memory > /sys/devices/system/memory/probe

Then, [start_address_of_new_memory, start_address_of_new_memory +
memory_block_size] memory range is hot-added.

But we can only hot-add *one section one time* by this way.
Whether we can add an argument on behalf of the count of the sections to add ?
So we can can hot-add *several sections one time*. Just like:

% echo start_address_of_new_memory count_of_sections > /sys/devices/system/memory/probe

Then, [start_address_of_new_memory, start_address_of_new_memory +
count_of_sections * memory_block_size] memory range is hot-added.

If this proposal is reasonable, i will send a patch to realize it.

Any suggestions ?

Best regards.

