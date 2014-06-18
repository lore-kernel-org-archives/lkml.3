Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964945AbaFRBJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:09:25 -0400
Received: from mail1.windriver.com ([147.11.146.13]:38330 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaFRBJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:09:22 -0400
Message-ID: <53A0E6A8.6070803@windriver.com>
Date: Wed, 18 Jun 2014 09:08:56 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: <mina86@mina86.com>, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406171017090.1187-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406171017090.1187-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 10:18 PM, Alan Stern wrote:
> That is a strange question to ask.  If you did not know that I approved
> the patch, why did you insert my Acked-By:?

I added your Acked-By, as when you reviewed V3, you mentioned that I 
*may* add your Acked-by in this patch. If I misunderstood your point, I 
am so sorry for that.

Best Regards
Wei

> With that change, you may add
>
> Acked-by: Alan Stern<stern@rowland.harvard.edu>
>
> Alan Stern

