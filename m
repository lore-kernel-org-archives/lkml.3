Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaHRNQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 09:16:39 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53104 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751488AbaHRNQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 09:16:27 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: myungjoo.ham@samsung.com
Cc: "Hernandez\, Carlos" <ceh@ti.com>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "orjan.eide\@arm.com" <orjan.eide@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
References: <2126088679.390471407886644188.JavaMail.weblogic@epmlwas02a>
Date: Mon, 18 Aug 2014 14:15:48 +0100
In-Reply-To: <2126088679.390471407886644188.JavaMail.weblogic@epmlwas02a>
	(=?utf-8?B?Iu2VqOuqheyjvCIncw==?= message of "Tue, 12 Aug 2014 23:37:25
 +0000 (GMT)")
Message-ID: <9hhsikuey63.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

함명주 <myungjoo.ham@samsung.com> writes:

>> ------- Original Message -------
>> Sender : Hernandez, Carlos<ceh@ti.com>
>> Date : 2014-08-12 22:49 (GMT+09:00)
>> Title : RE: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
>> 
>> Acked-By: Carlos Hernandez 
>> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Punit Agrawal
>> Sent: Friday, July 18, 2014 10:10 AM
>> To: linux-pm@vger.kernel.org; linux-samsung-soc@vger.kernel.org
>> Cc: orjan.eide@arm.com; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; MyungJoo Ham; Kyungmin Park
>> Subject: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
>> 
>> From: Ørjan Eide 
>> 
>> These functions are indended for use by drivers and should be available also when the driver is built as a module.> 
>> 
>> Cc: MyungJoo Ham 
>> Cc: Kyungmin Park 
>> Signed-off-by: Ørjan Eide 
>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
>
> There will be some modifications to this patch for consistency with
> other pending patches, but please don't worry about them. I'll handle
> them while merging this.

Great! Thanks MyungJoo.

>
>
> Cheers,
> MyungJoo.
>
>> ---
>> drivers/devfreq/devfreq.c |    3 +++
>> 1 file changed, 3 insertions(+)
>
>
>
> --
> MyungJoo Ham (함명주), PHD
> Frontier CS Lab, Software Center
> Samsung Electronics
> Cell: +82-10-6714-2858--
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
