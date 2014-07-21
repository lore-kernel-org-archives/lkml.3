Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbaGURgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:36:07 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53769 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932502AbaGURgF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:36:05 -0400
From: Punit Agrawal <punit.agrawal@arm.com>
To: myungjoo.ham@samsung.com
Cc: "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-samsung-soc\@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "orjan.eide\@arm.com" <orjan.eide@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        =?utf-8?B?67CV6rK966+8?= <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/2] PM / devfreq: Export helper functions for drivers
References: <32148397.172891405898897186.JavaMail.weblogic@epml01>
Date: Mon, 21 Jul 2014 18:35:25 +0100
In-Reply-To: <32148397.172891405898897186.JavaMail.weblogic@epml01>
	(=?utf-8?B?Iu2VqOuqheyjvCIncw==?= message of "Sun, 20 Jul 2014 23:28:17
 +0000 (GMT)")
Message-ID: <9hh8unmr4wy.fsf@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

함명주 <myungjoo.ham@samsung.com> writes:

> Sender : Punit Agrawal<punit.agrawal@arm.com>
>> From: Ørjan Eide 
>>
>> These functions are indended for use by drivers and should be available
>> also when the driver is built as a module.
>>
>> Cc: MyungJoo Ham 
>> Cc: Kyungmin Park 
>> Signed-off-by: Ørjan Eide 
>
> Dear Punit,

Hi MyungJoo,

>
>
> Just being curious, is there any reason not to use EXPORT_SYMBOL_GPL ?

No reason other than to match the existing EXPORT_SYMBOLs in this file.

Would you prefer this and the following patch to use EXPORT_SYMBOL_GPL
instead?

>
>
> Cheers,
> MyungJoo.
>
> --
> MyungJoo Ham (함명주), PHD
> Frontier CS Lab, Software Center
> Samsung Electronics
> Cell: +82-10-6714-2858--
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
