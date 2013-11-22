Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3KVAyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:54:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:54076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3KVAyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:54:14 -0500
Message-ID: <528EAB34.6010105@codeaurora.org>
Date: Thu, 21 Nov 2013 16:54:12 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vinayak Kale <vkale@apm.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        tglx <tglx@linutronix.de>, Will Deacon <will.deacon@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH V4 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
References: <1384946021-22100-1-git-send-email-vkale@apm.com>	<1384946021-22100-2-git-send-email-vkale@apm.com>	<528CFC77.5050200@codeaurora.org>	<CAPrCYkefGMfweREk8bBKsO2VY4Tnc-fUZW8sw_K5ugRj5zJUFA@mail.gmail.com> <CAPrCYkdpHPPY6D1dj5R=QJ5mtmKUfTx+M7wRMV-t2LrZMdSW9w@mail.gmail.com>
In-Reply-To: <CAPrCYkdpHPPY6D1dj5R=QJ5mtmKUfTx+M7wRMV-t2LrZMdSW9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/13 22:10, Vinayak Kale wrote:
> [removing chris.smith@st.com]
>
> On Thu, Nov 21, 2013 at 11:36 AM, Vinayak Kale <vkale@apm.com> wrote:
>> On Wed, Nov 20, 2013 at 11:46 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>> On 11/20/13 03:13, Vinayak Kale wrote:
>>>> This patch adds an accessor function for IRQ_PER_CPU flag.
>>>> The accessor function is useful to dertermine whether an IRQ is percpu or not.
>>>>
>>>> Signed-off-by: Vinayak Kale <vkale@apm.com>
>>>> ---
>>> This looks like a copy of Chris Smith's patch. Shouldn't Chris be the
>>> author and the commit text be whatever Chris sent?
>> In the cover letter of this patch series I did mention about Chris's
>> earlier patch. I didn't know his email-id earlier, have found the
>> mail-id now. CCing the mail-id to check whether it's still valid.
>>
> Chris's mail-id doesn't seem to be valid, the earlier mail to his
> mail-id [chris.smith@st.com] bounced.
> Please let me know in such case how to mention original author's credits.

It's up to the maintainer accepting the patch. If I was picking up the
patch I would say it doesn't really matter if the mail-id is valid
anymore. Leave the original patch intact and just add your sign-off. If
you took the patch and significantly changed it it's good to put
"Based-on-a-patch-by:" and then take over authorship.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

