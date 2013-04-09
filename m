Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DIUZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:25:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51727 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935899Ab3DIUZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:25:08 -0400
Message-ID: <5164790E.7@zytor.com>
Date: Tue, 09 Apr 2013 13:24:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org> <1365113821-22749-5-git-send-email-yinghai@kernel.org> <20130409134544.GA6320@redhat.com> <CAE9FiQUETs0AGjd+72GOz=Pm=9QicM7L46OaiMwhtUFa65TTvA@mail.gmail.com>
In-Reply-To: <CAE9FiQUETs0AGjd+72GOz=Pm=9QicM7L46OaiMwhtUFa65TTvA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 01:05 PM, Yinghai Lu wrote:
>>
>> So crashkernel=X@Y;high is a valid syntax? Looks like we will reserve
>> X amount of RAM at base Y and ignore "high" or "low".
> 
> yes, we should reject them.
> 

What if there isn't X amount of RAM available at base Y?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

