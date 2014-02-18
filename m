Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaBRWcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:32:43 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:64564 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaBRWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:32:39 -0500
Message-ID: <5303ED9A.6020302@cogentembedded.com>
Date: Wed, 19 Feb 2014 02:32:42 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Courtney Cavin <courtney.cavin@sonymobile.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com> <1392729681-21022-3-git-send-email-iivanov@mm-sol.com> <53039E2E.2030503@cogentembedded.com> <1392743648.17130.17.camel@iivanov-dev> <5303A71B.7060208@cogentembedded.com> <20140218213428.GM1706@sonymobile.com>
In-Reply-To: <20140218213428.GM1706@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/19/2014 12:34 AM, Courtney Cavin wrote:

>>>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

>>>>> Allows controller to be specified via device tree.
>>>>> Pass PHY phandle specified in DT to core driver.

>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>>>> ---
>>>>>     drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
>>>>>     1 file changed, 22 insertions(+), 1 deletion(-)

>>>>       You also need to describe the binding you're creating in
>>>> Documentation/devicetree/bindings/usb/<file>.txt.

>>> Did you check "[PATCH v2 1/3]"?

>>      Did you send it to 'linux-usb'? I just didn't get the patch.
>> (Typically, the bindings are described in the same patch the DT support is
>> added to the driver bu YMMV, of course.)

> Although I would personally agree that this is the most logical method,
> it would appear that the DT guys disagree with us [1].  Lately, they

    Thank you for the reference.

> seem to have either given up or are otherwise preoccupied, so perhaps
> you can still slip a few patches by them. ;)

    Yeah, I was at last able to get my Ethernet driver bindings applied. :-)

> -Courtney

> [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/submitting-patches.txt

WBR, Sergei

