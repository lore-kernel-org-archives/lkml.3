Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3AYJmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:42:37 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48050 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3AYJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:42:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpo=WUS6cjce70v_UvAfhTcW1RKHFYU3EPMjY8Z-+1kic5A@mail.gmail.com>
References: <CAOh2x=kqEzw9cvg=WLpjEbF50aTKCUUVd9GzNg8PqtBx_BpYLg@mail.gmail.com>
	<1359032849-25551-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=nnrEo69W7sBES85KgF0+WUy8Ouoq+SG1XiB54e7QLiow@mail.gmail.com>
	<1359104204.12502.101.camel@smile>
	<CAHp75Vex-t=q4aQtBsJHiu-r8u98UDPvcbgQi3Z+42dkQWL+YA@mail.gmail.com>
	<CAKohponpZa5Lzf-0p_porTuidL+LhZX3xrHzkwnC6ffTMchRQg@mail.gmail.com>
	<CAHp75Vd_1iozR20gHO46fqVQMBrJ43rXbWrLKCesJcqxE5QAhA@mail.gmail.com>
	<CAOh2x==-amzWv_8s736LQ4AXi35kQY3q3VFLmSaTFBG7A_d0BA@mail.gmail.com>
	<CAHp75Vf5ukEv=dp+RtaYHxfJ+vVDKTjmexh0teaJOOR9prR1ig@mail.gmail.com>
	<CAKohpo=WUS6cjce70v_UvAfhTcW1RKHFYU3EPMjY8Z-+1kic5A@mail.gmail.com>
Date: Fri, 25 Jan 2013 11:42:34 +0200
Message-ID: <CAHp75Vck=q9QwNa3DCq7h4jUdBj-ZHJEo7VsQFKFPJRnQD6G1A@mail.gmail.com>
Subject: Re: [PATCH v3.5] dw_dmac: return proper residue value
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:39 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 25 January 2013 15:07, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:
>> Yeah, the keyword is "look". 1 per million cases it could be true. I
>> think this discussion is going to the dead end.
>> Anyone else would like to argue for one or the other opinion?
>>
>> I might obey your way with the commentary that with quite lower
>> possibility we could have an issue there.
>
> :)
> Okay, lets keep your version.
>
> @Vinod: you are free to pick these patches now ;)

I do patch v4 to gather everything together.

-- 
With Best Regards,
Andy Shevchenko
