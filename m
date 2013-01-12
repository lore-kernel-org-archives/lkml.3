Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3ALSK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 13:10:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33829 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab3ALSK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 13:10:27 -0500
Message-ID: <50F1A6FE.3040909@zytor.com>
Date: Sat, 12 Jan 2013 10:10:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, David Woodhouse <dwmw2@infradead.org>,
        mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, David.Woodhouse@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86: Default to ARCH= x86 to avoid overriding
 CONFIG_64BIT
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <20130112170647.GA10659@liondog.tnic> <50F1A004.4090200@zytor.com> <20130112180845.GB10630@liondog.tnic>
In-Reply-To: <20130112180845.GB10630@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 10:08 AM, Borislav Petkov wrote:
> On Sat, Jan 12, 2013 at 09:40:20AM -0800, H. Peter Anvin wrote:
>> Hiding it because it happens to be in a slightly illogical place seems
>> completely backwards.
>
> Sure, that's the lazy dude solution™ :-)
>
> I could try to restructure arch/x86/Kconfig but is it worth the trouble
> to fix the "slightly illogical" placing...
>

Well, it's more than that.  It is actually removing functionality 
because it is "illogically placed"... that cure is worse than the disease.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

