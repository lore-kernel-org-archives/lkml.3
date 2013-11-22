Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab3KVGpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:45:14 -0500
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:36930 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750819Ab3KVGpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:45:11 -0500
MIME-Version: 1.0
In-Reply-To: <528EAB34.6010105@codeaurora.org>
References: <1384946021-22100-1-git-send-email-vkale@apm.com>
	<1384946021-22100-2-git-send-email-vkale@apm.com>
	<528CFC77.5050200@codeaurora.org>
	<CAPrCYkefGMfweREk8bBKsO2VY4Tnc-fUZW8sw_K5ugRj5zJUFA@mail.gmail.com>
	<CAPrCYkdpHPPY6D1dj5R=QJ5mtmKUfTx+M7wRMV-t2LrZMdSW9w@mail.gmail.com>
	<528EAB34.6010105@codeaurora.org>
Date: Fri, 22 Nov 2013 12:15:10 +0530
Message-ID: <CAPrCYkcrtDXQxCn-CY7UnX3etL7FHu-H2P-NGe+WFh6-=_2czQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
From: Vinayak Kale <vkale@apm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "jcm@redhat.com" <jcm@redhat.com>, tglx <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 6:24 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 11/20/13 22:10, Vinayak Kale wrote:
>> [removing chris.smith@st.com]
>>
>> On Thu, Nov 21, 2013 at 11:36 AM, Vinayak Kale <vkale@apm.com> wrote:
>>> On Wed, Nov 20, 2013 at 11:46 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>> On 11/20/13 03:13, Vinayak Kale wrote:
>>>>> This patch adds an accessor function for IRQ_PER_CPU flag.
>>>>> The accessor function is useful to dertermine whether an IRQ is percpu or not.
>>>>>
>>>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>>>> ---
>>>> This looks like a copy of Chris Smith's patch. Shouldn't Chris be the
>>>> author and the commit text be whatever Chris sent?
>>> In the cover letter of this patch series I did mention about Chris's
>>> earlier patch. I didn't know his email-id earlier, have found the
>>> mail-id now. CCing the mail-id to check whether it's still valid.
>>>
>> Chris's mail-id doesn't seem to be valid, the earlier mail to his
>> mail-id [chris.smith@st.com] bounced.
>> Please let me know in such case how to mention original author's credits.
>
> It's up to the maintainer accepting the patch. If I was picking up the
> patch I would say it doesn't really matter if the mail-id is valid
> anymore. Leave the original patch intact and just add your sign-off. If
> you took the patch and significantly changed it it's good to put
> "Based-on-a-patch-by:" and then take over authorship.
>
Thanks for the info.

I have made a minor change w.r.t. Chris's original patch: changed the
accessor function name from irq_is_per_cpu() to irq_is_percpu() since
I think irq_is_percpu() name is more inline with other *percpu* kernel
functions.

I will put Chris's sign-off as well as mine. I hope tglx will be fine with this.
