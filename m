Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3AXPgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 10:36:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58434 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab3AXPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 10:36:32 -0500
Message-ID: <510154C1.4060601@zytor.com>
Date: Thu, 24 Jan 2013 09:35:29 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Ingo Molnar <mingo@kernel.org>,
        ling.ma.program@gmail.com, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Ma Ling <ling.ml@alipay.com>
Subject: Re: [Suggestion] [x86]: Compiler Option Os is better on latest x86
References: <1356503537-4987-1-git-send-email-ling.ma@alipay.com> <20130124141733.GA14876@gmail.com> <20130124144612.GC13471@pd.tnic> <51014B9A.5080500@zytor.com> <20130124152544.GA13504@pd.tnic>
In-Reply-To: <20130124152544.GA13504@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 09:25 AM, Borislav Petkov wrote:
> On Thu, Jan 24, 2013 at 08:56:26AM -0600, H. Peter Anvin wrote:
>> There has been occasional talk about a -Ok(ernel) option to gcc, but
>> that would require someone to go through gcc and figure out what bits
>> makes sense and which don't...
> 
> Yep, such an option has a great potential for us and, if done right,
> would be very cool. It could probably be taught to insert HWEIGHT,
> RDRAND, CLFLUSH and whatever other insns we have the inline asm versions
> for... and query CPUID before that... uuh, nice stuff.
> 
> The alternative would be to fork gcc and call it kcc...
> 
> /me runs away pretty quickly without even turning back :-)
> 

I don't expect we'll be teaching gcc about the alternatives mechanism.
-Ok was about optimization, basically a "sane -Os".

	-hpa

