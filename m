Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaBRRb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:31:59 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:42566 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBRRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:31:56 -0500
Message-ID: <5303A71B.7060208@cogentembedded.com>
Date: Tue, 18 Feb 2014 21:31:55 +0300
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
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>	 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>	 <53039E2E.2030503@cogentembedded.com> <1392743648.17130.17.camel@iivanov-dev>
In-Reply-To: <1392743648.17130.17.camel@iivanov-dev>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 08:14 PM, Ivan T. Ivanov wrote:

>>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

>>> Allows controller to be specified via device tree.
>>> Pass PHY phandle specified in DT to core driver.

>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>> ---
>>>    drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
>>>    1 file changed, 22 insertions(+), 1 deletion(-)

>>      You also need to describe the binding you're creating in
>> Documentation/devicetree/bindings/usb/<file>.txt.

> Did you check "[PATCH v2 1/3]"?

    Did you send it to 'linux-usb'? I just didn't get the patch.
(Typically, the bindings are described in the same patch the DT support is 
added to the driver bu YMMV, of course.)

> Regards,
> Ivan

WBR, Sergei

