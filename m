Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab3COMAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:00:37 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:62874 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab3COMAf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:00:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130314154811.GA3001@arwen.pp.htv.fi>
References: <1363242239-1061-1-git-send-email-kishon@ti.com>
	<1363242239-1061-3-git-send-email-kishon@ti.com>
	<20130314154811.GA3001@arwen.pp.htv.fi>
Date: Fri, 15 Mar 2013 14:00:33 +0200
Message-ID: <CANOLnOMxej7dSbQeVKZEjEN+WAFR5qLz5hO0q8NiPvQguNKcgw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] usb: otg: twl4030: use devres API for regulator
 get and request irq
From: Grazvydas Ignotas <notasas@gmail.com>
To: balbi@ti.com
Cc: Kishon Vijay Abraham I <kishon@ti.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, tony@atomide.com
Content-Type: text/plain; charset=ISO-8859-13
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 5:48 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Thu, Mar 14, 2013 at 11:53:57AM +0530, Kishon Vijay Abraham I wrote:
>> Used devres APIs devm_request_threaded_irq and devm_regulator_get for
>> requesting irq and for getting regulator respectively.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>
> please refresh this on top of my testing branch, you should be patching
> drivers/usb/phy/phy-twl4030-usb.c

Does that mean I need to rebase my series on your testing branch too?

>
> --
> balbi

-- 
Graþvydas
