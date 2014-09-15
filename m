Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbaIOWul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:50:41 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39160 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbaIOWug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:50:36 -0400
Message-ID: <54176D43.3070103@gmail.com>
Date: Tue, 16 Sep 2014 06:50:43 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/4] drivers/xen/xenbus/xenbus_client.c: Several
 improvements for it
References: <54157282.40402@gmail.com> <5417063C.9070204@citrix.com>
In-Reply-To: <5417063C.9070204@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:31 PM, David Vrabel wrote:
> On 14/09/14 11:48, Chen Gang wrote:
>> They are all for 'xenbus_client.c', please help check when you have time,
>> thanks.
>>
>> Chen Gang (4):
>>   drivers/xen/xenbus/xenbus_client.c: Remove redundancy assignment to 'addr'
>>   drivers/xen/xenbus/xenbus_client.c: Correct the comments for xenbus_grant_ring()
>>   drivers/xen/xenbus/xenbus_client.c: Remove BUG_ON() when error string trucated
>>   drivers/xen/xenbus/xenbus_client.c: Improve the failure processing for __xenbus_switch_state()
> 
> The prefix should be the subsystem not the file (files move around).
> i.e., xen/xenbus.
> 

OK, thanks, I shall notice about it when send patch v2 for it.

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
