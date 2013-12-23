Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592Ab3LWX0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 18:26:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49044 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564Ab3LWX0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 18:26:21 -0500
Message-ID: <52B8C675.30204@zytor.com>
Date: Mon, 23 Dec 2013 15:25:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>
CC: Matt Fleming <matt@console-pimps.org>, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	<1387448416-11672-1-git-send-email-jlee@suse.com>	<20131219104908.GE3145@console-pimps.org>	<1387459939.3539.4092.camel@linux-s257.site> <20131220112955.75e82a86@alan.etchedpixels.co.uk>
In-Reply-To: <20131220112955.75e82a86@alan.etchedpixels.co.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 03:29 AM, One Thousand Gnomes wrote:
> On Thu, 19 Dec 2013 21:32:19 +0800
> joeyli <jlee@suse.com> wrote:
> 
>> 於 四，2013-12-19 於 10:49 +0000，Matt Fleming 提到：
>>> On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
>>>> From: Jan Beulich <JBeulich@suse.com>
>>>>
>>>> Other than ix86, x86-64 on EFI so far didn't set the
>>>> {g,s}et_wallclock accessors to the EFI routines, thus
>>>> incorrectly using raw RTC accesses instead.
> 
> Probably wise.
> 
> Before anyone reverts that please make sure it also works on EFI32,
> because right now we crash and burn on multiple EFI32 tablets querying
> the time.
> 

Quite -- we in fact did just the opposite (checkin 04bf9ba720fc).

	-hpa

