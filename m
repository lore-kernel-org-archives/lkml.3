Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662Ab3DCP1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:27:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40176 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759408Ab3DCP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:27:19 -0400
Message-ID: <515C4A40.3030904@zytor.com>
Date: Wed, 03 Apr 2013 08:26:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, Matt Fleming <matt.fleming@intel.com>, tglx@linutronix.de,
        mjg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix rebuild with EFI_STUB enabled
References: <515C5D2502000078000CA6AD@nat28.tlf.novell.com> <5a3182e0-580a-42f4-a17f-925836cca7d2@email.android.com> <515C5FD002000078000CA6DA@nat28.tlf.novell.com>
In-Reply-To: <515C5FD002000078000CA6DA@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 07:58 AM, Jan Beulich wrote:
>>>> On 03.04.13 at 16:48, "H. Peter Anvin" <hpa@zytor.com> wrote:
>> This looks awesome for 3.10, but getting a minimal fix for 3.9/stable would 
>> be good, too.
> 
> Do you really view this as relevant for stable? Considering that this
> had been this way for a while with apparently no-one having noticed,
> I wouldn't think so. Nor would I see a strong need for this to go into
> 3.9.
> 
> Jan
> 

Since it is a build fix, I think I do.  You never quite know who build
problems is going to bite, and I'd rather just fix them as long as the
fix is suitably small and obvious.  It doesn't exactly help that kbuild
is hideously fragile.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

