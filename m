Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3LDIcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:32:42 -0500
Received: from 20.mo1.mail-out.ovh.net ([188.165.45.168]:58116 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754549Ab3LDIck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:32:40 -0500
Message-ID: <529EE8A5.7010806@overkiz.com>
Date: Wed, 04 Dec 2013 09:32:37 +0100
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Douglas Gilbert <dgilbert@interlog.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
References: <Pine.LNX.4.44L0.1312031030390.1226-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1312031030390.1226-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16877239604868773990
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrkeehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan,

On 03/12/2013 16:32, Alan Stern wrote:
> On Tue, 3 Dec 2013, Nicolas Ferre wrote:
>
>> On 03/12/2013 15:07, Boris BREZILLON :
>>> Replace clk_get calls by devm_clk_get calls.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> Tested-by: Robert Nelson <robertcnelson@gmail.com>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> Thanks Boris for these fixes.
>>
>> Alan, Greg, can you take the whole series as fixes for 3.13?
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Sorry, but I forgot to add your Signed-off-by in the 2nd version of this
series.
>
> The patches look fine to me.  But only the 1/3 patch fixes a bug; the
> others merely change the resource management.

Do you want me to split this series ?
  1) the 1st patch that should be merged in 3.13
  2) patches 2 to 4 that might be applied later

Best Regards,

Boris

>
> Alan Stern
>

