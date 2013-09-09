Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3IIFeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 01:34:09 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:57008 "EHLO
	vsp-authed-01-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177Ab3IIFeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 01:34:06 -0400
Message-ID: <522D5DAB.2060707@gaisler.com>
Date: Mon, 09 Sep 2013 07:33:31 +0200
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>
CC: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] usb: gadget: Add UDC driver for Aeroflex Gaisler GRUSBDC
References: <1376316310-27989-1-git-send-email-andreas@gaisler.com> <521DBC9E.9080001@gaisler.com>
In-Reply-To: <521DBC9E.9080001@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-08-28 11:02, Andreas Larsson wrote:
> On 2013-08-12 16:05, Andreas Larsson wrote:
>> This adds an UDC driver for GRUSBDC USB Device Controller cores
>> available in the
>> GRLIB VHDL IP core library. The driver only supports DMA mode.
>
> Any comments? It would be great to get feedback soon in case some things
> need to be changed for this driver to be accepted. Thanks!

Anyone?

Is there anything holding it back from being accepted into mainline?
The patch has been waiting for almost a month now for any reaction.

Best regards,
Andreas Larsson

