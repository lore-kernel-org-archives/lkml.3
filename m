Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbaCTRot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:44:49 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:60921 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342AbaCTRor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:44:47 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 2/3] mtd: davinci-nand: add dts property for NAND_NO_SUBPAGE_WRITE option
From: Warner Losh <imp@bsdimp.com>
In-Reply-To: <532B2766.6090506@ti.com>
Date: Thu, 20 Mar 2014 11:44:43 -0600
Cc: Brian Norris <computersforpeace@gmail.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        David Woodhouse <dwmw2@infradead.org>, galak@codeaurora.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        grygorii.strashko@ti.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Murali Karicheri <m-karicheri2@ti.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <D69011BE-C37F-4085-B992-45F6F32AF1D0@gmail.com>
References: <1395335184-4745-1-git-send-email-ivan.khoronzhuk@ti.com> <1395335184-4745-3-git-send-email-ivan.khoronzhuk@ti.com> <532B2183.2080309@ti.com> <20140320172912.GW31517@norris-Latitude-E6410> <532B2766.6090506@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 20, 2014, at 11:37 AM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> 
> 
> On Thursday 20 March 2014 01:29 PM, Brian Norris wrote:
>> On Thu, Mar 20, 2014 at 01:12:35PM -0400, Santosh Shilimkar wrote:
>>> Boris,
>> 
>> Who's Boris? And why should Boris be taking this patch? It's an MTD
>> patch.
>> 
> I got your name completely wrong. Sorry....
> 
>>> On Thursday 20 March 2014 01:06 PM, Ivan Khoronzhuk wrote:
>>>> From: Murali Karicheri <m-karicheri2@ti.com>
>>>> 
>>>> After testing NAND flash with ubifs for k2hk-emv board were committed
>>>> that flash doesn't support subpage writing, so we can fix it by
>>>> adding a property to disable subpage write.
>> 
>> What flash? We try to autodetect NAND as much as possible. Perhaps we
>> should be adding infrastructure support instead of hacking it with a DT
>> property.
>> 
> We can't auto detect it and thats why the DT approach was taken. We
> will double check that.

I though sub page writing was one of the fields in the onfi and/or jedec(toggle) meta data structures. Have you looked there?

Warner

