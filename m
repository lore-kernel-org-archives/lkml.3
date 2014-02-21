Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaBUTR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:17:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57663 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbaBUTRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:17:54 -0500
Message-ID: <5307A651.5030604@zytor.com>
Date: Fri, 21 Feb 2014 11:17:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: davem@davemloft.net, Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        dborkman@redhat.com, ffusco@redhat.com, tgraf@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/hash: fix build failure with older binutils
References: <53073962020000780011E2DE@nat28.tlf.novell.com> <68ae560f-8cf7-4083-816f-3fa78aed9a87@email.android.com> <53076DBC020000780011E552@nat28.tlf.novell.com>
In-Reply-To: <53076DBC020000780011E552@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 06:16 AM, Jan Beulich wrote:
>>>> On 21.02.14 at 13:51, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> How old?
> 
> 2.16.91.0.5 (SLE10)
> 

I would *love* to kill off binutils 2.16.  It was a horribly buggy
version, and it has been hard to deal with keeping things alive with it.
 How important is this?

Since this is the first I've heard of this being broken, I am kind of
encouraged that maybe we can move on?

	-hpa


