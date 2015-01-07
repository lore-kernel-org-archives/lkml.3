Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbbAGPSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:18:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48818 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbbAGPSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:18:50 -0500
Message-ID: <54AD4E58.10209@oracle.com>
Date: Wed, 07 Jan 2015 10:18:48 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, konrad.wilk@oracle.com,
        jgross@suse.com
CC: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/xen: Free bootmem in free_p2m_page()
 during early boot
References: <1420639734-24808-1-git-send-email-boris.ostrovsky@oracle.com> <54AD4C62.6030301@citrix.com>
In-Reply-To: <54AD4C62.6030301@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 10:10 AM, David Vrabel wrote:
> On 07/01/15 14:08, Boris Ostrovsky wrote:
>> With recent changes in p2m we now have legitimate cases when
>> p2m memory needs to be freed during early boot (i.e. before
>> slab is initialized).
>>
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Applied to to stable/for-linus-3.19, thanks.
>
> If I understand correctly this didn't fully fix your 32-bit dom0 crashes?

No, this only allowed me to be alive for a few more microseconds ;-)

-boris
