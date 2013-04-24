Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab3DXGIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 02:08:11 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:53106 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3DXGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 02:08:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_VCEdN-qfu4-yZk847hYbBi=5dtGFKYGPYJDRQ0PAkKQ@mail.gmail.com>
References: <1366388860-18735-1-git-send-email-linkinjeon@gmail.com>
	<1366598966.31792.1.camel@kjgkr>
	<CAKYAXd_VCEdN-qfu4-yZk847hYbBi=5dtGFKYGPYJDRQ0PAkKQ@mail.gmail.com>
Date: Wed, 24 Apr 2013 15:08:08 +0900
Message-ID: <CAKYAXd-YL-OwW2bRc+YS6E8_OtmKk+rC-LXzc4p6X3Veitee5A@mail.gmail.com>
Subject: Re: [PATCH 2/2] f2fs: add REQ_META about metadata requests for submit bio
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>
>>> +	if (type == META)
>>
>> Should be if (btype == META).
>> Thanks,
> Yes, Right :)
> Thanks for fixing.
Hi. Jaegeuk.
Should I resend the fixed patch as above your comment ?

Thanks.
>>
>>> +		rw |= REQ_META;
>>> +
>>>  	if (sbi->bio[btype]) {
>>>  		struct bio_private *p = sbi->bio[btype]->bi_private;
>>>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync,
>>
>> --
>> Jaegeuk Kim
>> Samsung
>>
>
