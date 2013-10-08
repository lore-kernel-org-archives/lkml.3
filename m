Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3JHR5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:57:43 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38892 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3JHR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:57:40 -0400
Message-ID: <52544792.1080005@codeaurora.org>
Date: Tue, 08 Oct 2013 10:57:38 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Andi Shyti <andi@etezian.org>, Kumar Gala <galak@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Use of drivers/platform and matching include?
References: <BC1C47B3-5412-4829-A1D9-AAB04694D1CC@codeaurora.org> <20131007064852.GC5896@jack.whiskey>
In-Reply-To: <20131007064852.GC5896@jack.whiskey>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/2013 11:48 PM, Andi Shyti wrote:
> Hi,
>
>> As we look at upstreaming more support for the Qualcomm MSM SoCs there are a number of drivers or library like routines that are unique to the MSM platform, we are thinking that putting them under:
> just a question, is this code the one you have already in
> codeaurora for 8974/8226/8626/8610 etc?

Yes.
> Thanks,
> Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

