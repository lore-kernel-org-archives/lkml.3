Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaBSTYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:24:16 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:47848 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbaBSTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:24:14 -0500
Message-ID: <530512F1.3060304@cogentembedded.com>
Date: Wed, 19 Feb 2014 23:24:17 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>		 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>		 <53039E2E.2030503@cogentembedded.com>	 <1392743648.17130.17.camel@iivanov-dev>	 <5303A71B.7060208@cogentembedded.com> <1392824921.17130.71.camel@iivanov-dev>
In-Reply-To: <1392824921.17130.71.camel@iivanov-dev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 02/19/2014 06:48 PM, Ivan T. Ivanov wrote:

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

>>      Did you send it to 'linux-usb'?

> Opps, sorry. get_maintainer.pl did not list linux-usb and I forgot
> to add it. Would like to resend it?

    I guess so, since the binding document would go in thru the USB tree 
anyway, IIUC.

> Regards,
> Ivan

WBR, Sergei

