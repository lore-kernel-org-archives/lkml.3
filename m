Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751071Ab3CAENW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 23:13:22 -0500
Received: from relay.parallels.com ([195.214.232.42]:35026 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3CAENV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 23:13:21 -0500
Message-ID: <51302AAC.6030400@parallels.com>
Date: Fri, 1 Mar 2013 08:12:28 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 00/10] ipc MSG_COPY fixes
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>  <512C69EA.8020603@parallels.com> <1361880000.3235.3.camel@thor.lan>
In-Reply-To: <1361880000.3235.3.camel@thor.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.29.37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

26.02.2013 16:00, Peter Hurley пишет:
> On Tue, 2013-02-26 at 11:53 +0400, Stanislav Kinsbursky wrote:
>> Looks good to me. Thanks you, Peter!
>>
>> Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
>>
>> Next time please, add maintainer to "To" list instead of "CC" list (no need to resend - I've added Andrew Morton to "To" list in this reply).
>
> Ok.
>
>>> Can the alloc_msg() be further simplified to allocate one block with
>>> vmalloc() and link the msg segments in-place?
>
> Any thoughts on this suggestion?
>

Emm... You can do so, is you want.
But this will be just an optimisation on a slow-path. I.e. I have nothing
to object, but don't see any other reason except striving for perfection.

> Regards,
> Peter Hurley
>


-- 
Best regards,
Stanislav Kinsbursky
