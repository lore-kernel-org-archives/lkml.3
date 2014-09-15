Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603AbaIOWxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:53:49 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57899 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbaIOWxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:53:46 -0400
Message-ID: <54176E00.6040309@gmail.com>
Date: Tue, 16 Sep 2014 06:53:52 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        xen-devel@lists.xenproject.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/4] drivers/xen/xenbus/xenbus_client.c: Correct
 the comments for xenbus_grant_ring()
References: <54157282.40402@gmail.com> <541572F6.3090900@gmail.com> <54170579.9040406@citrix.com>
In-Reply-To: <54170579.9040406@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 11:27 PM, David Vrabel wrote:
> On 14/09/14 11:50, Chen Gang wrote:
>> Both zero and positive number can indicate success, so the original
>> comments need be improved.
>>
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>> ---
>>  drivers/xen/xenbus/xenbus_client.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
>> index 277e74d..e2cf681 100644
>> --- a/drivers/xen/xenbus/xenbus_client.c
>> +++ b/drivers/xen/xenbus/xenbus_client.c
>> @@ -361,8 +361,8 @@ static void xenbus_switch_fatal(struct xenbus_device *dev, int depth, int err,
>>   * @ring_mfn: mfn of ring to grant
>>  
>>   * Grant access to the given @ring_mfn to the peer of the given device.  Return
>> - * 0 on success, or -errno on error.  On error, the device will switch to
>> - * XenbusStateClosing, and the error will be saved in the store.
>> + * 0 or positive number on success, or -errno on error.  On error, the device
>> + * will switch to XenbusStateClosing, and the error will be saved in the store.
> 
> If you're going to update this comment, please state what it is actually
> returning: i.e., a grant reference or -ve on error.
> 

OK, thanks, I shall update it when send patch v2 for it.

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
