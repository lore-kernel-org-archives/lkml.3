Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3IZBTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:19:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27870 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab3IZBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:19:54 -0400
Message-ID: <52438BBF.8060307@oracle.com>
Date: Thu, 26 Sep 2013 09:19:59 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: Re: [PATCH 2/3 v3] Refactor MSI restore call-chain to drop unnecessary
 argument
References: <521EB76B.8090903@oracle.com> <CAErSpo5_Vhs5cN-1dUz051b+P0ZrUH1xuM+bkVe4C4ycMyLTNQ@mail.gmail.com>
In-Reply-To: <CAErSpo5_Vhs5cN-1dUz051b+P0ZrUH1xuM+bkVe4C4ycMyLTNQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


于 2013-09-26 06:22, Bjorn Helgaas 写道:
> On Wed, Aug 28, 2013 at 8:52 PM, Zhenzhong Duan
> <zhenzhong.duan@oracle.com> wrote:
>> ...
>> -v3: Update patch description per Konrad suggestion, thanks.
>>
>> Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
>> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> Zhenzhong, would you mind reposting the entire series as a v4 with all
> updates and acks?  I'm not sure I can collect all the right pieces.
>
> Thanks,
>    Bjorn
There are some updates in upstream that conflict with mine since I wrote 
my patches.
So I rewrte the patches based on upstream and send to Konrad.
He will buy a qlogic card and help a test. I'll repost those after that.

thanks
zduan
