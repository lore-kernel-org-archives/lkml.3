Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbaIOSMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:12:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54189 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425AbaIOSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:12:33 -0400
Message-ID: <54172C18.60009@cogentembedded.com>
Date: Mon, 15 Sep 2014 21:12:40 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/9] usb: rename gen_phy to phy in HCD
References: <1410777309-12552-1-git-send-email-antoine.tenart@free-electrons.com> <1410777309-12552-6-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1410777309-12552-6-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/2014 1:35 PM, Antoine Tenart wrote:

> The patch adding support to the generic PHY framework introduced a
> 'gen_phy' member in the HCD structure. Rename it to 'phy' to have a
> consistent USB framework.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

    With my recent patches we don't need this anymore. I considered quite 
stupid renaming the field which hasn't been even added yet, so just returned 
to my earlier version which called the field in question 'phy'.

WBR, Sergei

