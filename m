Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaLJIrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 03:47:39 -0500
Received: from exprod7og112.obsmtp.com ([64.18.2.177]:44456 "EHLO
	exprod7og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbaLJIrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 03:47:37 -0500
From: Sumit Saxena <sumit.saxena@avagotech.com>
References: <lfdrro7paac7tbj4ofn0f3dk.1416224479458@email.android.com>
 <1085092fd0c2eadae3a0f8de3ee09b95@mail.gmail.com> <547A89E9.6010804@gmail.com>
In-Reply-To: <547A89E9.6010804@gmail.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIZVD3YB+seSCiXxc7PWq9+KpzrzAGBlajoAsHfI6ub0+aOUA==
Date: Wed, 10 Dec 2014 14:17:34 +0530
Message-ID: <a308c0f17b7938d3c0f35409f0a4f000@mail.gmail.com>
Subject: RE: [PATCH] drivers: scsi: megaraid: Add "megaraid_sas_internal.h"
 for internal shared functions using
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Chen Gang [mailto:gang.chen.5i5j@gmail.com]
>Sent: Sunday, November 30, 2014 8:37 AM
>To: Sumit Saxena
>Cc: megaraidlinux@lsi.com; linux-scsi@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH] drivers: scsi: megaraid: Add "megaraid_sas_internal.h"
>for internal shared functions using
>
>On 11/17/14 19:51, Sumit Saxena wrote:
>>> -----Original Message-----
>>> From: Chen Gang [mailto:gang.chen.5i5j@gmail.com]
>>> Sent: Monday, November 17, 2014 5:17 PM
>>> To: Sumit Saxena
>>> Cc: megaraidlinux@lsi.com; linux-scsi@vger.kernel.org; linux-
>>> kernel@vger.kernel.org
>>> Subject: RE: [PATCH] drivers: scsi: megaraid: Add
>"megaraid_sas_internal.h"
>>> for internal shared functions using
>>>
>>>
>>> OK, I will send patch v2 for it.
>>>
>>> I sent this patch based on Linux next tree, please tell me the tree
>>> location (git
>>> address) which I shall base on for sending patch v2.
>>
>> I posted the patch series today, once the patches make it to scsi-next
>> tree, I will let you know.
>>
>
>Is it OK?  or if possible, please help rebase and send the patch for it
>based on
>the related branches and patches.
Sorry for delay in response, patch series sent by me is accepted at
upstream. Please rebase "for-next" branch of scsi.git, here is git address
of tree-
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

Please sent out patch v2, I will ACK.

Thanks
Sumit

>
>Thanks.
>--
>Chen Gang
>
>Open, share, and attitude like air, water, and life which God blessed
