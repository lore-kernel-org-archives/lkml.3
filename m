Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaGQDku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 23:40:50 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:55978 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbaGQDkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 23:40:47 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 23:40:47 EDT
MIME-Version: 1.0
In-Reply-To: <20140716203011.GA22844@kroah.com>
References: <1405509923-29422-1-git-send-email-kiran.padwal21@gmail.com>
	<20140716203011.GA22844@kroah.com>
Date: Thu, 17 Jul 2014 09:04:38 +0530
Message-ID: <CA+neC=Mz9h14K18jXXCPmyXNLEAXVNZ1b4p2X=WeORYo5d_FgQ@mail.gmail.com>
Subject: Re: [PATCH] Staging: gdm724x: fix missing blank line after variable declaration
From: kiran padwal <kiran.padwal21@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Rusty Russell <rusty@rustcorp.com.au>,
        =?UTF-8?B?R8O8bMWfYWggS8O2c2U=?= <gulsah.1004@gmail.com>,
        Won Kang <wkang77@gmail.com>, peter.p.waskiewicz.jr@intel.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Kiran Padwal <kiran.padwal@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 17, 2014 at 2:00 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Wed, Jul 16, 2014 at 04:55:23PM +0530, Kiran Padwal wrote:
>> From: Kiran Padwal <kiran.padwal@gmail.com>
>>
>> Checkpatch fix - Add missing blank line after variable declaration
>>
>> Signed-off-by:Kiran Padwal <kiran.padwal21@gmail.com>
>
> Minor nit, you need a ' ' after the ':'.
>
> Also, you sent me two different patches, with the same Subject: line.
> So I can't apply either of them, sorry.  Please resend both of them with
> better subject lines (hint, put the filename in the subject: that would
> fix this...)

Thanks, I will resend it.

>
> thanks,
>
> greg k-h
