Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbaCTVYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:24:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37869 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759889AbaCTVYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:24:01 -0400
Message-ID: <532B6A79.3070802@cogentembedded.com>
Date: Fri, 21 Mar 2014 01:23:53 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: =?ISO-8859-1?Q?C=E9dric_Cabessa?= <ced@ryick.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coding style: fix line over 80 characters
References: <1395266697-8699-1-git-send-email-ced@ryick.net>	 <1395266697-8699-3-git-send-email-ced@ryick.net>	 <532B5ED1.8060406@cogentembedded.com> <1395348314.7776.47.camel@joe-AO722>
In-Reply-To: <1395348314.7776.47.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2014 11:45 PM, Joe Perches wrote:

>>> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> []
>>> @@ -271,12 +271,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
>>>    			}
>>>    			break;
>>>    		case USB_PORT_FEAT_POWER:
>>> -			usbip_dbg_vhci_rh(" ClearPortFeature: USB_PORT_FEAT_POWER\n");
>>> +			usbip_dbg_vhci_rh(
>>> +				" ClearPortFeature: USB_PORT_FEAT_POWER\n");

>>      Your version of scripts/checkpatch.pl seems outdated. It shouldn't
>> complain about strings violating 80-column limit (and I've just verified it
>> doesn't).

> checkpatch complains about > 80 char lines for lines with
> a function where the function name isn't understood to be
> a logging use.

> uspip_dbg_<foo> doesn't take the general form so if the
> string at the EOL exceeds 80 chars, a message is emitted.

> Long standalone strings on a single line do not get warnings.

    OK, but there's still issue that the patch context doesn't correspond to 
what can be seen in Greg's tree. What I am seeing there is broken up string.

WBR, Sergei

