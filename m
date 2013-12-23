Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab3LWMQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 07:16:35 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:41342 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757047Ab3LWMQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 07:16:33 -0500
Message-ID: <52B82982.4040906@gaisler.com>
Date: Mon, 23 Dec 2013 13:16:02 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Robert Baldyga <r.baldyga@samsung.com>, Felipe Balbi <balbi@ti.com>
CC: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v4] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
References: <1387456805-16610-1-git-send-email-andreas@gaisler.com> <52B31149.7020503@samsung.com>
In-Reply-To: <52B31149.7020503@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 04:31 PM, Robert Baldyga wrote:
> Hi Andreas,
>
> According to changes in gadget API, which I did in this patch
> http://permalink.gmane.org/gmane.linux.usb.general/100108 you should
> initialize endpoints with ep_set_maxpacket_limit() function.
>
> I described needed changes in your code (in gr_ep_init() function).

Hi!

Thank you for the feedback! Added to v5.

Best regards,
Andreas Larsson


