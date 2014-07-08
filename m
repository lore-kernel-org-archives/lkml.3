Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaGHLkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:40:51 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:50203 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754479AbaGHLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:40:48 -0400
Message-ID: <53BBD8BC.7040602@vmware.com>
Date: Tue, 08 Jul 2014 13:40:44 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Masaru Nomura <massa.nomura@gmail.com>, airlied@linux.ie,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/3] gpu: drm: Remove unnecessary parameter from drm_ht_remove_item()
References: <1403646734-2838-1-git-send-email-massa.nomura@gmail.com> <1403646734-2838-3-git-send-email-massa.nomura@gmail.com> <20140708112442.GA17271@phenom.ffwll.local>
In-Reply-To: <20140708112442.GA17271@phenom.ffwll.local>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 01:24 PM, Daniel Vetter wrote:
> On Tue, Jun 24, 2014 at 10:52:13PM +0100, Masaru Nomura wrote:
>> removed drm_open_hash from drm_ht_remove_item() as the parameter is
>> not used within the function.
>>
>> Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
>> ---
>> Please review this patch carefully. The reason the parameter is passed
>> might be some historical one or clarity of which drm_open_hash
>> we remove an item from.
> Reasons for this are probably lost. On the patch:
>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Acked-by: Thomas Hellstrom <thellstrom@vmware.com>

>
> Aside: Imo we could/should just move all the users to directly employ the
> linux hashtab instead of partially reinventing the wheel here in drm.
> -Daniel
>

Actually, in this case, the wheel was invented in drm before it was made
generic :).
It's possible to utilize part of "hashtable.h" but I don't think the
code size gain
will be major...

/Thomas
