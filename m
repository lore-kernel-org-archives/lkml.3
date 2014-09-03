Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635AbaICVoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:44:37 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:32953 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaICVof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:44:35 -0400
Message-ID: <54078BBF.3030600@cogentembedded.com>
Date: Thu, 04 Sep 2014 01:44:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Antoine Tenart <antoine.tenart@free-electrons.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, Peter.Chen@freescale.com, kishon@ti.com,
        stern@rowland.harvard.edu
CC: yoshihiro.shimoda.uh@renesas.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/9] usb: rename phy to usb_phy in HCD
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com> <1409730040-14200-5-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1409730040-14200-5-git-send-email-antoine.tenart@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/03/2014 11:40 AM, Antoine Tenart wrote:

> The USB PHY member of the HCD structure is renamed to 'usb_phy' and
> modifications are done in all drivers accessing it.

> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

    I'm going to steal this patch and post it along with the HCD generic PHY 
support to avoid the need for the follow-up 'gen_phy'->'phy' rename.

WBR, Sergei

