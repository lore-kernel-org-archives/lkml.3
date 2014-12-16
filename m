Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaLPB7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 20:59:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:12507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaLPB7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 20:59:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,583,1413270000"; 
   d="scan'208";a="654524202"
Message-ID: <548F9205.8060901@intel.com>
Date: Tue, 16 Dec 2014 09:59:33 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Zhang Rui <rui.zhang@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6] Thermal: introduce INT3406 thermal driver
References: <54868CF6.6020505@intel.com>	<CAOesGMirF-_H2ZzFR-VpwkEErZE2uQJSYx5EuePArQsEh=r_Kw@mail.gmail.com>	<20141211010226.GA26253@aaronlu.sh.intel.com>	<CAOesGMj_uObbxLdpobEhP=nRPsFUJNCtq01RH7ZSECd5=1Ti6Q@mail.gmail.com>	<1418265472.12435.68.camel@rzhang1-toshiba>	<548934D0.8000502@intel.com>	<1418286781.12435.73.camel@rzhang1-toshiba>	<54895821.3050902@intel.com> <CAOesGMjKdi6wPsy+U1makbFyJpsj8RZykOZ5BEYrFWj_VzUxqA@mail.gmail.com>
In-Reply-To: <CAOesGMjKdi6wPsy+U1makbFyJpsj8RZykOZ5BEYrFWj_VzUxqA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/14 02:18, Olof Johansson wrote:
> Hi,
> 
> 
> 
> On Thu, Dec 11, 2014 at 12:38 AM, Aaron Lu <aaron.lu@intel.com> wrote:
>> INT3406 ACPI device object resembles an ACPI video output device, but its
>> _BCM is said to be deprecated and should not be used. So we will make
>> use of the raw interface to do the actual cooling. Due to this, the
>> backlight core has some modifications. Also, to re-use some of the ACPI
>> video module's code, one function has been exported.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>> v6: Fix an issue that wrongly set error path return value as reported
>> by Olof Johansson.
> 
> Last night's -next was still broken. I take it this wasn't applied
> yet? Please at least revert the original patch.

Indeed, not yet.
I believe Rui is waiting for you to confirm that the patch indeed
fix your problem, so can you please kindly give it a test? Thanks.

-Aaron

> 
> 
> -Olof
> 

