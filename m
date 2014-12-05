Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611AbaLEDMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:12:00 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:53101 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098AbaLEDL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:11:57 -0500
From: Ashley Lai <ashley@ashleylai.com>
X-Google-Original-From: Ashley Lai <alai@ant>
Date: Thu, 4 Dec 2014 21:11:55 -0600 (CST)
To: Joe Perches <joe@perches.com>
cc: Ashley Lai <ashleydlai@gmail.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] tpm_ibmvtpm: Update email address in maintainers
 list and ibmvtpm driver
In-Reply-To: <1417744666.2721.33.camel@perches.com>
Message-ID: <alpine.DEB.2.10.1412042111250.13729@ant>
References: <1417742242-13016-1-git-send-email-ashleydlai@gmail.com> <1417744666.2721.33.camel@perches.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Joe.  I just resubmitted.

--Ashley

On Thu, 4 Dec 2014, Joe Perches wrote:

> On Thu, 2014-12-04 at 19:17 -0600, Ashley Lai wrote:
>> Added myself as a maintainer for the IBM vtpm driver and removed myself
>> from the tpm maintainer list. Also, updated the tpm_ibmvtpm driver with
>> my current email address.
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -9297,13 +9297,19 @@ F:	drivers/media/usb/tm6000/
>>
>>  TPM DEVICE DRIVER
>>  M:	Peter Huewe <peterhuewe@gmx.de>
>> -M:	Ashley Lai <ashley@ashleylai.com>
>>  M:	Marcel Selhorst <tpmdd@selhorst.net>
>>  W:	http://tpmdd.sourceforge.net
>>  L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
>>  S:	Maintained
>>  F:	drivers/char/tpm/
>>
>> +IBM VTPM DEVICE DRIVER
>> +M:	Ashley Lai <ashleydlai@gmail.com>
>> +W:	http://tpmdd.sourceforge.net
>> +L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
>> +S:	Maintained
>> +F:	drivers/char/tpm/tpm_ibmvtpm*
>> +
>
> Please keep this file sections in alphabetical order
>
>
