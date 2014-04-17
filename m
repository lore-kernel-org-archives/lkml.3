Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbaDQQMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:12:23 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48832 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDQQMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:12:14 -0400
Subject: Re: [PATCH v3 0/7] Introducing (yet again) Device Tree Overlays
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
In-Reply-To: <CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
Date: Thu, 17 Apr 2014 19:12:07 +0300
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <7706B5FF-45EB-4860-BD12-204B341A510D@konsulko.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com> <CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
To: delicious quinoa <delicious.quinoa@gmail.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Ugh, very sorry for the late reply; my mailer filed this somewhere I don't look at very frequently.

On Mar 28, 2014, at 8:27 PM, delicious quinoa wrote:

> On Tue, Mar 18, 2014 at 4:55 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> The following patchset introduces Device Tree overlays, a method
>> of dynamically altering the kernel's live Device Tree, along with
>> a generic interface to use it in a board agnostic manner.
>> 

[snip]

> \
> I did some debug, haven't figured anything out yet.
> 
> I have been able to successfully add/remove an overlay if it was to a
> fpga node that was at /fpga and used 'target = <&fpga>;'   Also
> 'target-path="/fpga";' works fine.
> 

Yes, platform devices are broken; I carry a patch that fixes all of that mess, and I intend to follow up with it.

> Alan Tull
> aka
> delicious quinoa
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Regards

-- Pantelis

