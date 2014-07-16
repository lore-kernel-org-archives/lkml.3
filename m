Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaGPXIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 19:08:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:48649 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbaGPXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 19:08:13 -0400
Message-ID: <53C705DB.3040700@codeaurora.org>
Date: Wed, 16 Jul 2014 16:08:11 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
References: <20140716032655.GB30412@kroah.com> <53C6C2C5.1050804@codeaurora.org> <20140716184409.GB10633@kroah.com> <53C6D4B6.3030506@codeaurora.org>
In-Reply-To: <53C6D4B6.3030506@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/14 12:38, Stephen Boyd wrote:
> On 07/16/14 11:44, Greg KH wrote:
>> My specific question is why 2 different interfaces?
> Ok. It definitely looks odd to support set/get of the VDD with sysfs and
> ioctl interfaces. I'm just guessing, but I suspect it's a permissions
> thing given that the patch that introduces the VDD stuff also updates
> the permissions of the device node. Of course, the commit text only
> mentions an ioctl, nothing about sysfs. The only other sysfs stuff seems
> to be module parameters to change the vendor ids.
>
> I'll have to go repo diving to figure out if the sysfs interface was
> ever used. Maybe Alex or Konstantin can respond before I have to do that.
>
>

I couldn't find any usage of the sysfs interface. The only thing I see
used is the host_name field when the module is inserted, if that even
happens at all (I'm not sure because it's behind some ifdef that may or
may not be defined). Sorry this doesn't explain why there are two
different interfaces for the VDD stuff. Hopefully Alex or Konstantin can
help.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

