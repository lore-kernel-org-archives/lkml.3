Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3JKGXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:23:54 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42073 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3JKGXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:23:52 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-d4-525799757db3
Message-id: <52579967.6020306@samsung.com>
Date: Fri, 11 Oct 2013 08:23:35 +0200
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v3] USB: gadget: s3c-hsotg: add isochronous transfers
 support
References: <1381300917-7468-1-git-send-email-r.baldyga@samsung.com>
 <20131010160428.GV28375@radagast>
In-reply-to: <20131010160428.GV28375@radagast>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7qlM8ODDD6dVrSY9bKdxWLjjPWs
	Fgfv11s0L17PZnG26Q27xeVdc9gsFi1rZbZYe+QuuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGV1b37MX/GOp+HxnJ0sD43/mLkZODgkBE4m5F4+wQdhiEhfurQey
	uTiEBJYySqyb8okZwvnIKLF1yU0mkCpeAS2JlpvzWEBsFgFViXlTf7OD2GwCOhJbvk9gBLFF
	BcIkjjb9ZIWoF5T4MfkeWL2IgIDE+heX2EGGMgtcZpTovLQTbKiwQLDErLcLwU4SEsiQuHb/
	AlARBwengJ5ExwEHkDAz0Pz9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CULWBkXsUomlqaXFCc
	lJ5rqFecmFtcmpeul5yfu4kREuRfdjAuPmZ1iFGAg1GJh9eCITxIiDWxrLgy9xCjBAezkgiv
	WwVQiDclsbIqtSg/vqg0J7X4ECMTB6dUA+PmvS/9zW6VH9v3YOt5jyutT9+996zNzu1/yBog
	fOnA7Ld7BGQ0eSo39glPvrE/4X2BXLKbwv0o76eKjX2njks/sv3bMkO2K+PElIPVX07+T39b
	LMYjrL2x91r8hLtPiln3rY+sN5+zSW7ukaUrhM3TVn17/atoj+rCj39Y75Y9uTotycHAaOIJ
	JZbijERDLeai4kQAG/RJgVACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/10/2013 06:04 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Oct 09, 2013 at 08:41:57AM +0200, Robert Baldyga wrote:
>> @@ -2616,14 +2630,19 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>>  	s3c_hsotg_set_ep_maxpacket(hsotg, hs_ep->index, mps);
>>  
>>  	/* default, set to non-periodic */
>> +	hs_ep->isochronous = 0;
>>  	hs_ep->periodic = 0;
>>  	hs_ep->halted = 0;
> 
> this hunk doesn't apply because of this hs_ep->halted line, which patch
> does this depend on ?
> 
it depends on http://www.spinics.net/lists/linux-usb/msg94025.html

Best regards
Robert Baldyga
Samsung R&D Institute Poland
