Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaAXS1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:27:41 -0500
Received: from smtp.citrix.com ([66.165.176.89]:41512 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXS1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:27:39 -0500
X-IronPort-AV: E=Sophos;i="4.95,714,1384300800"; 
   d="scan'208";a="96275904"
Message-ID: <52E2B098.1060509@citrix.com>
Date: Fri, 24 Jan 2014 18:27:36 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nikolay Aleksandrov <nikolay@redhat.com>, Jay Vosburgh <fubar@us.ibm.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        Andy Gospodarek <andy@greyhouse.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] bonding: Use do_div to divide 64 bit numbers
References: <1390502838-21581-1-git-send-email-zoltan.kiss@citrix.com> <52E17F40.4040004@redhat.com> <52E18720.4060008@redhat.com>
In-Reply-To: <52E18720.4060008@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 21:18, Nikolay Aleksandrov wrote:
>> Hi Zoltan,
>> Thanks for fixing this, a few comments though:
>> bond->params.miimon can be 0 here that's why there's a check afterwards,
>> also please separate the local variable definitions from the body with a
>> new line.
>> The same applies for downdelay.
>>
>> Nik
> In fact since we don't need the u64 and newval->value is limited to
> INT_MAX, can't we simply cast it to (int) and avoid the do_div entirely ?
Yep, that's even better, thanks for fixing it!

Zoli
