Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab3FYIp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:45:28 -0400
Received: from eu1sys200aog122.obsmtp.com ([207.126.144.153]:32899 "EHLO
	eu1sys200aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab3FYIpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:45:04 -0400
Message-ID: <51C95774.9060709@st.com>
Date: Tue, 25 Jun 2013 09:40:20 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v5] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372089195-29219-1-git-send-email-srinivas.kandagatla@st.com> <51C8A6C8.8000009@codeaurora.org> <51C8B551.9080203@st.com> <51C8C172.8020207@codeaurora.org>
In-Reply-To: <51C8C172.8020207@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thankyou for the comments,
On 24/06/13 23:00, Stephen Boyd wrote:
> On 06/24/13 14:08, Srinivas KANDAGATLA wrote:
>> On 24/06/13 21:06, Stephen Boyd wrote:
>>> On 06/24/13 08:53, Srinivas KANDAGATLA wrote:
>
> 
> I think the problem is your clockevent has no rating. Please give it a
> rating (300?) so that it prevents the dummy from taking over. You don't
> need to worry about disabling the local timer API, it will register a
> harmless clockevent with a low rating (100) that should be ignored.
> 
I think I forgot to add rating in my last attempt to use cpu notifier.
With rating set to 300, the driver works fine with cpu notifiers.
Will send a new patch.

Thanks,
srini

