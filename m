Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965051Ab3DIQtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:49:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49887 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879Ab3DIQtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:49:51 -0400
Message-ID: <51644698.2010203@zytor.com>
Date: Tue, 09 Apr 2013 09:49:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to crashkernel=;high/low
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org> <1365113821-22749-5-git-send-email-yinghai@kernel.org> <20130409134544.GA6320@redhat.com> <b591d6e4-5468-48f1-8b7e-c6a3943214cd@email.android.com> <20130409164720.GJ6320@redhat.com>
In-Reply-To: <20130409164720.GJ6320@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 09:47 AM, Vivek Goyal wrote:
> On Tue, Apr 09, 2013 at 08:00:57AM -0700, H. Peter Anvin wrote:
>> Please, no semicolons. We already have established syntax for suboptions (option=suboption,suboption,...) and suboptions with parameters (option=suboption:value,...)
> 
> Ok, to understand it better, so crashkernel= will look as follows?
> 
> crashkernel=suboption[,suboption[,....]][@offset]
> 
> A suboption can be.
> 
> - A memory value (128[KMG])
> - A range with value (range:size)
> - Or a property influencing memory allocation behavior (e.g high or low)
> 
> If yes, sounds good.
> 

Sorry, I don't quite grok @offset and range:size here.

What exactly does those bits do?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

