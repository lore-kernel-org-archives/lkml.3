Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab3I1UdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 16:33:23 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:53439 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab3I1UdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 16:33:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgEFABK/CFEY1KI3/2dsb2JhbABEFr54F3OCHgEBBTgeBhIKARALCw0JFg8JAwIBAgEPAhYeBg0BBQICh3oBAw4BDK8ih1MKGScNWYh8jBKEeAOLDYkqgVaBHIRShUuFEoMT
X-IPAS-Result: AgEFABK/CFEY1KI3/2dsb2JhbABEFr54F3OCHgEBBTgeBhIKARALCw0JFg8JAwIBAgEPAhYeBg0BBQICh3oBAw4BDK8ih1MKGScNWYh8jBKEeAOLDYkqgVaBHIRShUuFEoMT
X-IronPort-AV: E=Sophos;i="4.84,565,1355115600"; 
   d="scan'208";a="29326840"
Message-ID: <52473D1C.5010003@gmail.com>
Date: Sat, 28 Sep 2013 16:33:32 -0400
From: Woody Suwalski <terraluna977@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Firefox/24.0 SeaMonkey/2.21
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.12 regression: i915 warnings
References: <52442A3C.3010407@gmail.com>	<CAKMK7uFvP7zisHL4UFjRqBX8mxS4DtosF2AFnwZDSdMgnDf4Lw@mail.gmail.com>	<5245C004.7070907@gmail.com> <CAKMK7uFZ35gruMYHB+LXEDVoAof7n-1oYGxWkky_tLe3ELLxWQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFZ35gruMYHB+LXEDVoAof7n-1oYGxWkky_tLe3ELLxWQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Vetter wrote:
> On Fri, Sep 27, 2013 at 7:27 PM, Woody Suwalski <terraluna977@gmail.com> wrote:
>> Daniel Vetter wrote:
>>> On Thu, Sep 26, 2013 at 2:36 PM, Woody Suwalski <terraluna977@gmail.com>
>>> wrote:
>>>> Daniel, I have noticed these warnings on 3.12-rc1, did not go away on
>>>> 3.12-rc2.
>>>> I see it only on EeePC with i915,not on ThinkPad with Radeon.
>>>> It is a 32-bit kernel with overlayfs and TuxOnIce patches, so not
>>>> perfectly
>>>> clean, however same config and patches on 3.11 do not show these issues.
>>>> No,sorry, did not have time to investigate further or bisect.If you have
>>>> a
>>>> quick test in mind - I will try ;-)
>>>
>>> a) Please always cc: relevant mailing lists, not just your maintainer.
>>> b) Please retest with latest drm-intel-fixes from
>>> http://cgit.freedesktop.org/~danvet/drm-intel/
>>> c) If that doesn't help please boot with drm.debug=0xe, reproduce the
>>> issue once and attach the complete dmesg. Please make sure that it
>>> contains everything from boot-up to the WARN.
>>>
>>> Thanks, Daniel
>> For now I can do the last - a complete dmesg with drm.debug attached...
>> I have hoped that you were to reply "Yawn, an old issue..." 8-)
> Here we go: Mode flag mismatch in the tv encoder, should be fixed with
>
> http://cgit.freedesktop.org/~danvet/drm-intel/commit/?id=1062b81598bc00e2f6620e6f3788f8f8df2f01e7
>
> Pull request is already out and patch is cc: stable, so should show up
> in a kernel near you soon.
> -Daniel
Warnings are gone with this patch (and other 4 patches  since 3.2.12-rc2 
from drm tree).

Thanks, Woody


