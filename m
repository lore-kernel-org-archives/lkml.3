Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3J0SgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 14:36:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50642 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3J0SgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:36:07 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <526D5D0E.5090604@roeck-us.net>
Date: Sun, 27 Oct 2013 11:35:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Rob Pearce <rob@flitspace.org.uk>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT
 and D425KT
References: <526D3BB6.6020902@flitspace.org.uk> <20131027173302.GA25812@kroah.com>
In-Reply-To: <20131027173302.GA25812@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2013 10:33 AM, Greg KH wrote:
> On Sun, Oct 27, 2013 at 04:13:42PM +0000, Rob Pearce wrote:
>> From: Rob Pearce <rob@flitspace.org.uk>
>>
>> The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
>> having LVDS but the hardware is not populated. This patch adds them to
>> the list of such systems. Patch is against 3.11.4
>>
>> Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
>> ---
>> Patch revised to match the D425KT exactly as the D425KTW does have LVDS.
>> According to Intel's documentation, the D410PTL and D410PLTW don't.
>
> Any reason you don't want this in the stable tree as well?
>

Hi Greg,

pardon my ignorance, but I thought this was supposed to be the maintainer's call to make ?
Did I get this wrong ?

Thanks,
Guenter




