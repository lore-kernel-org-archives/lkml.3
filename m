Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3LaVXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:23:31 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52611 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756575Ab3LaVXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:23:30 -0500
Message-ID: <52C335CE.8000603@gmail.com>
Date: Tue, 31 Dec 2013 22:23:26 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        jiada_wang@mentor.com, laurent.pinchart@ideasonboard.com,
        kyungmin.park@samsung.com
Subject: Re: [RESEND PATCH v7 1/5] omap3isp: Modify clocks registration to
 avoid circular references
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com> <1386177127-2894-2-git-send-email-s.nawrocki@samsung.com> <52AF7B4D.2010305@gmail.com> <20131219080729.18119.42456@quantum> <20131231193707.12054.68169@quantum>
In-Reply-To: <20131231193707.12054.68169@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2013 08:37 PM, Mike Turquette wrote:
> Quoting Mike Turquette (2013-12-19 00:07:29)
>> Quoting Sylwester Nawrocki (2013-12-16 14:14:37)
>>> Hi Mike,
>>>
>>> Laurent has already taken this patch into his tree, could you apply
>>> the remaining ones to your clk tree so this series has enough exposure
>>> in -next ?
>>
>> I've taken this in privately to do a little testing. If all goes well
>> then I'll push it out to clk-next very soon.
>
> This is in clk-next now. Hopefully nothing bad will happen when it hits
> linux-next ;-)

Thanks Mike. Yes, fingers crossed ;)

Regards,
Sylwester
