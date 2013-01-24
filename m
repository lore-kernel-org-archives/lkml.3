Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3AXRiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 12:38:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59675 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab3AXRh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 12:37:58 -0500
Message-ID: <5101710F.9060409@zytor.com>
Date: Thu, 24 Jan 2013 11:36:15 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        x86@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        tglx@linutronix.de, JBeulich@suse.com
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as special
 hypervisor interrupts
References: <1358992569-22826-1-git-send-email-kys@microsoft.com> <20130124092821.GA13463@pd.tnic> <04854149-91a3-4834-b2bb-de301c8241c9@email.android.com> <20130124173555.GJ13463@pd.tnic>
In-Reply-To: <20130124173555.GJ13463@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 11:35 AM, Borislav Petkov wrote:
> On Thu, Jan 24, 2013 at 06:11:32AM -0600, H. Peter Anvin wrote:
>> Sounds great in theory at least, as long as it doesn't mean pushing a
>> bunch of #ifdefs into other code.
> 
> Just one set in hypervisor.h but this is the RightWay™ we do it in the
> kernel :-).
> 
> Anyway, it turned out to be easier than I thought, just two patches
> which I'll be sending as a reply to this message. I'll run more
> randconfig tests on them, anyone sees issues please let me know.
> 

Awesome :)

	-hpa


