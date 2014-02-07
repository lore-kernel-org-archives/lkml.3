Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaBGPU7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:20:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42735 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751961AbaBGPU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:20:58 -0500
Date: Fri, 7 Feb 2014 10:20:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Zoran Markovic <zoran.markovic@linaro.org>
cc: lkml <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: Re: [RFC PATCHv2] usb: move hub init and LED blink work to power
 efficient workqueue
In-Reply-To: <CAME+o4nK+hOs+TygwzVzDBTUMfF7dWs9WVg2FTMSt6neYckVtA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1402071018400.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't top-post.

On Fri, 7 Feb 2014, Zoran Markovic wrote:

> I believe there may still be use cases where you want to wake up the
> same CPU that scheduled the work.

Won't the majority of cases not care which CPU is used?  Therefore,
shouldn't the default behavior be to use the power-efficient work
queue?

> Thanks for the Ack. Can you please queue this for 3.14?

That's up to Greg KH.  He may decide it's not important enough to go 
into 3.14, and delay it until 3.15.

Alan Stern

