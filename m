Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaI3KFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:05:24 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41524 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaI3KFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:05:19 -0400
Message-ID: <542A81AB.3050702@gmail.com>
Date: Tue, 30 Sep 2014 18:10:51 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        ian.campbell@citrix.com, wei.liu2@citrix.com,
        boris.ostrovsky@oracle.com, bhelgaas@google.com, jgross@suse.com,
        yongjun_wei@trendmicro.com.cn, mukesh.rathor@oracle.com
CC: xen-devel@lists.xenproject.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/xenbus: Use 'void' instead of 'int' for the return
 of xenbus_switch_state()
References: <5425961A.5000604@gmail.com> <542A7E0E.9050702@citrix.com>
In-Reply-To: <542A7E0E.9050702@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/30/14 17:55, David Vrabel wrote:
> On 26/09/14 17:36, Chen Gang wrote:
>> When xenbus_switch_state() fails, it will call xenbus_switch_fatal()
>> internally, so need not return any status value, then use 'void' instead
>> of 'int' for xenbus_switch_state() and __xenbus_switch_state().
>>
>> Also need be sure that all callers which check the return value must let
>> 'err' be 0.
>>
>> And also need change the related comments for xenbus_switch_state().
> 
> Since this patch does not fix a bug and there is no unanimous agreement
> on the API change I'm not going to apply it (nor the previous version).
> 

OK, at least for me, it is no problems.

But I still recommend to improve it in the future, it is not a good idea
to let all related things remain in current condition (for me, at lease
need some related code comments for it).


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
