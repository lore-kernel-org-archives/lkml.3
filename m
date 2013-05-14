Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3ENQRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:17:30 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49379 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3ENQR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:17:29 -0400
Message-ID: <51926396.4040203@linaro.org>
Date: Tue, 14 May 2013 09:17:26 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: sync the CMOS RTC as well as
 the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-4-git-send-email-david.vrabel@citrix.com> <51918ABB.5030501@linaro.org> <51920A9502000078000D5D84@nat28.tlf.novell.com> <51925F70.5000309@linaro.org> <51927F2002000078000D6224@nat28.tlf.novell.com>
In-Reply-To: <51927F2002000078000D6224@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 09:14 AM, Jan Beulich wrote:
>>>> On 14.05.13 at 17:59, John Stultz <john.stultz@linaro.org> wrote:
>> On 05/14/2013 12:57 AM, Jan Beulich wrote:
>>>>>> On 14.05.13 at 02:52, John Stultz <john.stultz@linaro.org> wrote:
>>>> Honestly, it seems a little strange to me. If you're running as dom0,
>>>> why does HYPERVISOR_dom0_op() not cause the hypervisor to set the cmos
>>>> its virtualizing? This seems to mess with the proper virtualization
>>>> layering.
>>> Thy hypervisor tries to control as little system and peripheral devices
>>> as possible, and the CMOS (including the clock) is among those not
>>> controlled by it, but by Dom0.
>> Huh. So what does calling HYPERVISOR_dom0_op do then?
> Here it merely tells the hypervisor that the wall clock changed (so
> it can propagate this on to DomU-s).

Ok, I appreciate the explanation. Still waiting for acks on this one.

thanks
-john
