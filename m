Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab3FRRde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:33:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60176 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab3FRRdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:33:32 -0400
Message-ID: <51C099D2.3090506@zytor.com>
Date: Tue, 18 Jun 2013 12:33:06 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] x86, mtrr: fixs for mtrr_cleanup
References: <1371154622-8929-1-git-send-email-yinghai@kernel.org> <51C08B01.40200@zytor.com> <CAE9FiQXM=mgvUqLh_Uj9NA8fMOSt+zCz-ev-ujnVkhHm8fQW_g@mail.gmail.com>
In-Reply-To: <CAE9FiQXM=mgvUqLh_Uj9NA8fMOSt+zCz-ev-ujnVkhHm8fQW_g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 12:28 PM, Yinghai Lu wrote:
> On Tue, Jun 18, 2013 at 9:29 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> On this subject: what do we need to happen to be able to dump the MTRR
>> cleanup stuff?
> 
> the old x server like to add Write-combining entry in MTRR.
> looks like drm for mga200 is adding that too ?
>

"Old X server" here has been a long time now.  I need to dig into the
MGA200 I guess...

> We need to make them to use PAT instead.

Yes.

	-hpa


