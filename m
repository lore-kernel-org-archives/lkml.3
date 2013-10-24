Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3JXLua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:50:30 -0400
Received: from us02smtp2.synopsys.com ([198.182.60.77]:62332 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3JXLu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:50:29 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Chen Gang <gang.chen@asianux.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        "Catalin Marinas" <Catalin.Marinas@arm.com>
Subject: Re: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Thread-Topic: [PATCH] arc: kernel: add default extern variable 'screen_info'
 in "setup.c"
Thread-Index: AQHOz+CNfxdrFiqJVE276Bbxr7amHw==
Date: Thu, 24 Oct 2013 11:50:18 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075152ED0@IN01WEMBXA.internal.synopsys.com>
References: <5267AE7D.4080600@asianux.com>
 <C2D7FE5348E1B147BCA15975FBA23075152B30@IN01WEMBXA.internal.synopsys.com>
 <52688C42.3030907@asianux.com>
 <CAMuHMdWD1ENyrBMimnoYQc4hzJ_Zkob-1RQ3F+wXbSktYcO9xQ@mail.gmail.com>
 <5269032E.2060400@asianux.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.237]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 04:56 PM, Chen Gang wrote:
> If what you said is correct, could you help to send related patch for
> it? if I send this kind of patches, it will be easily redirected to
> "/dev/null".

Geert has explained the state of things quite nicely. Please send your patch to
introduce HAVE_xxx. I'm sure maintainers will respond to it as it is the correct
thing to do. But I don't want to add bloat to kernel for a random defconfig
failure which no one will really use for ARC.

If you think u can't/won't do it - let me know and I'll send the patches instead.

-Vineet
