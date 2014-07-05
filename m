Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaGESVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 14:21:34 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56004 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879AbaGESVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 14:21:33 -0400
Message-ID: <53B84236.6000006@cogentembedded.com>
Date: Sat, 05 Jul 2014 22:21:42 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Apelete Seketeli <apelete@seketeli.net>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
CC: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: musb: register nop transceiver driver for jz4740
References: <1404539245-9211-1-git-send-email-apelete@seketeli.net> <1404539245-9211-2-git-send-email-apelete@seketeli.net>
In-Reply-To: <1404539245-9211-2-git-send-email-apelete@seketeli.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 09:47 AM, Apelete Seketeli wrote:

> Following the name change of the nop transceiver driver in commit
> 4525bee, make sure to register the transceiver driver before calling

    Please also specify that commit's summary line in parens.

> usb_get_phy() to avoid issues related to accessing its data structure
> while it was not registered.

> Signed-off-by: Apelete Seketeli <apelete@seketeli.net>

WBR, Sergei

