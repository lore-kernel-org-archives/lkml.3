Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaBXL5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 06:57:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33883 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbaBXL5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 06:57:35 -0500
Message-ID: <530B3398.5080308@zytor.com>
Date: Mon, 24 Feb 2014 03:57:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: davem@davemloft.net, Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        dborkman@redhat.com, ffusco@redhat.com, tgraf@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/hash: fix build failure with older binutils
References: <53073962020000780011E2DE@nat28.tlf.novell.com> <68ae560f-8cf7-4083-816f-3fa78aed9a87@email.android.com> <53076DBC020000780011E552@nat28.tlf.novell.com> <5307A651.5030604@zytor.com> <530B0948020000780011E968@nat28.tlf.novell.com>
In-Reply-To: <530B0948020000780011E968@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2014 11:56 PM, Jan Beulich wrote:
>
> 2.17 doesn't have support for it either, yet has support for fxsaveq
> (which you can see in the patch context we check for too). Apart
> from that Documentation/Changes continues to state binutils 2.12
> to be the minimum requirement...
>

Documentation/Changes (maybe) reflects the minimums across all 
architectures, which really has never applied to any single architecture 
for a long time.  x86 requires gcc 3.4 at a minimum, for example, and it 
is not clear that that is sufficient anymore, either.

We don't really have good documentation about what the requirements for 
various specific arches are...

That being said, it sounds like this one is justified.

	-hpa


