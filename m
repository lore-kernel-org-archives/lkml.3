Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaEWPnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:43:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822AbaEWPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:43:49 -0400
Message-ID: <537F6C85.107@zytor.com>
Date: Fri, 23 May 2014 08:43:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor macros
 for writes
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com> <1400777250-17335-17-git-send-email-will.deacon@arm.com> <537E30AF.4070501@zytor.com> <20140523144604.GF21319@arm.com> <537F60E0.1060307@zytor.com> <20140523145758.GG21319@arm.com> <537F6728.3090600@zytor.com> <20140523153409.GI21319@arm.com>
In-Reply-To: <20140523153409.GI21319@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 08:34 AM, Will Deacon wrote:
> 
> There is also a documentation patch [1] in this series but, again, I didn't
> CC everybody on it. Sorry, but the level of interest this sort of stuff
> generates amongst kernel developers is close to zero so I only included
> people I thought cared on CC for the entire series. I'm stuck between a rock
> and a hard place trying to CC interested people whilst at the same time
> trying to avoid spamming all the arch maintainers.
> 

If you are sending me a patch, please include me on the cover letter for
the patch series.  You don't have to send me the entire patch series
(although for something like a Documentation patch which affects x86 I
would consider including the union list as well.)

I think regardless of level of interest, the definition of
cross-architectural operations is exactly the arch maintainers job, so
it isn't really out of place to "spam" us...

	-hpa

