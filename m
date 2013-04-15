Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935193Ab3DOIIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 04:08:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29628 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab3DOIIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 04:08:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,473,1363158000"; 
   d="scan'208";a="38488681"
Message-ID: <8c0a691851491a66c7df58b9a2ca89ec.squirrel@www.codeaurora.org>
In-Reply-To: <877gkipebd.fsf@octavius.laptop.org>
References: <1361705927-10524-1-git-send-email-ygardi@codeaurora.org>
    <26E7A31274623843B0E8CF86148BFE32B02F5779@NTXAVZMBX04.azit.micron.com>
    <877gkipebd.fsf@octavius.laptop.org>
Date: Mon, 15 Apr 2013 01:08:10 -0700
Subject: Re: [PATCH v1] mmc: card: Adding support for sanitize in eMMC 4.5
From: merez@codeaurora.org
To: "Chris Ball" <cjb@laptop.org>
Cc: "Luca Porzio \(lporzio\)" <lporzio@micron.com>,
        "Yaniv Gardi" <ygardi@codeaurora.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "tj\@kernel.org" <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris and Luca,

Sorry for the late response.
Yaniv is on vacation for the last month and will be back at the end of the
week.
We will add the HPI in case Sanitize times-out.

Thanks,
Maya

> Hi Yaniv, Maya,
>
> On Mon, Mar 11 2013, Luca Porzio (lporzio) wrote:
>> In case of Sanitize timeout, the eMMC might go in an unclear state.
>> May I suggest to:
>> - issue an HPI before leaving thus bring the eMMC back into safe status
>> - report the 'sanitize not complete error' and let the user decide on
>>   Whether he wants to re-issue (i.e. continue) the sanitize or just let
>>   it go.
>
> Can you respond to this review feedback from Luca, please?
>
> Thanks,
>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

