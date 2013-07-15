Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3GOJum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 05:50:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53048 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab3GOJul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 05:50:41 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jul 2013 05:50:41 EDT
Message-ID: <51E3C3E0.1050906@mev.co.uk>
Date: Mon, 15 Jul 2013 10:41:52 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130701 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "oliver@schinagl.nl" <oliver@schinagl.nl>,
        "linux@roeck-us.net" <linux@roeck-us.net>
Subject: Re: [PATCH v3 01/10] Driver core and sysfs changes for attribute
 groups
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-15 00:05, Greg Kroah-Hartman wrote:
> Ian, I didn't add a DEVICE_PATTR() macro yet, that can come later.  I
> considered it, but that would also mean a BUS_PATTR() and the like, which I
> guess works, but I hate even a _hint_ of "Hungarian" notation, which this
> implies.
>
> Anyone else have a better name for this macro:
> 	#define DEVICE_PATTR(_name)	&dev_attr_##_name.attr
> that they can think of?  It will cut down on the typing done for
> attribute lists.

DEVICE_ATTR_P or DEV_ATTR_P to save typing.  Or would that be confused 
with the P convention[1]?  If so, DEVICE_ATTR_PTR or DEV_ATTR_PTR could 
be used.

[1] see Jargon File.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
