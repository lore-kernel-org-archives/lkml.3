Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab3HTNTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:19:10 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54304 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021Ab3HTNTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:19:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130819160130.GD30073@sirena.org.uk>
References: <20130816224654.GV30073@sirena.org.uk>
	<Pine.LNX.4.44L0.1308162117240.24059-100000@netrider.rowland.org>
	<CACVXFVPFqHLQRpd0QBzoVapqHtKqrfGvWT0_nhXeFqjQVRsp5Q@mail.gmail.com>
	<20130819160130.GD30073@sirena.org.uk>
Date: Tue, 20 Aug 2013 21:19:07 +0800
Message-ID: <CACVXFVOi+pa7G-D91V05qF0Y65rX6ZKk-=i_sbFwL3PCGsdyPw@mail.gmail.com>
Subject: Re: Non-enumerable devices on USB and other enumerable buses
From: Ming Lei <tom.leiming@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:01 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Aug 19, 2013 at 08:17:53PM +0800, Ming Lei wrote:
>> On Sat, Aug 17, 2013 at 9:29 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
>> > Aong those lines, I would like to point out that the device concept
>> > embodied in the kernel's data structures can be pretty thin.  For
>> > example, it might be little more than a port number or bus address.
>
>> Maybe the principle behind drivers/usb/core/usb-acpi.c is helpful
>> for the problem, and DT may refer to ACPI to describe on-board
>> USB devices, and the way to retrieve platform data too.
>
> I can't parse this at all well - why would DT want to refer to ACPI, do
> you mean people may wish to look at the code as an example?  As Grant

I mean usb-acpi provides one approach to retrieve platform data for USB device
during device enumeration, and the idea might be helpful for you to implement
similar things based on DT.

> noted DT already has some mechanisms for enumerable buses which looking
> at the code appears to be broadly what that's doing.

If the mechanism is ready now, so looks you might post code for review
and discussion?


Thanks,
-- 
Ming Lei
