Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab3FMIgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:36:05 -0400
Received: from multi.imgtec.com ([194.200.65.239]:62227 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab3FMIgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:36:00 -0400
Message-ID: <51B98472.4090908@imgtec.com>
Date: Thu, 13 Jun 2013 09:36:02 +0100
From: Markos Chandras <Markos.Chandras@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <sergei.shtylyov@cogentembedded.com>, <paul.gortmaker@windriver.com>,
        <markos.chandras@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] drivers/net/ethernet/3com: Drop EISA dependency from
 VORTEX
References: <CAG2jQ8hACp_iGEXR7rXKR3sydK4O=y0paeh1FFgH2UisxWVxVA@mail.gmail.com> <51B78594.5050903@windriver.com> <51B78C82.7020709@cogentembedded.com> <20130613.013417.1870836967244200694.davem@davemloft.net>
In-Reply-To: <20130613.013417.1870836967244200694.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.58]
X-SEF-Processed: 7_3_0_01192__2013_06_13_09_35_58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/13 09:34, David Miller wrote:
> From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Date: Wed, 12 Jun 2013 00:45:54 +0400
>
>>     We have the user of 3Com EISA cards on this list and I've fixed EISA
>> specific bug in this driver not long ago.
>
> Then I obviously must reject this patch.
>
Hi David,

Yes please reject this patch

