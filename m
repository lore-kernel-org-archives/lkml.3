Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaH0KWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:22:14 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:49271 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaH0KWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:22:12 -0400
Message-ID: <53FDB27B.7040001@gmail.com>
Date: Wed, 27 Aug 2014 18:27:07 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/xen/grant-table.c: Be sure of unsigned value
 never comparing with 0
References: <53FCAA04.40009@gmail.com> <53FCBDD2.8040208@citrix.com> <53FCE338.1050304@gmail.com> <53FDADA5.6070802@citrix.com>
In-Reply-To: <53FDADA5.6070802@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/14 18:06, David Vrabel wrote:
> 
> Applied to devel/for-linus-3.18 with this description:
> 
>     xen/grant-table: refactor error cleanup in grow_gnttab_list()
> 
>     The cleanup loop in grow_gnttab_list() is safe from the underflow of
>     the unsigned 'i' since nr_glist_frames is >= 1, but refactor it
>     anyway.
> 

OK, thank you very much for your encouragement! And next, I shall try to
provide another patches for Xen (hope I can finish within this month).
And I should be more careful about the patches which I shall send.

Also I want to consult: "Is there a common test for Xen"? If there is,
please let me know, and I should try to perform the common test before
send any patches.

Welcome any additional ideas, suggestions, and completions.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
