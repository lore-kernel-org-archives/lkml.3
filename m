Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab3CLXlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:41:21 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:33132 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3CLXlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 19:41:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130312232410.GA29152@kroah.com>
References: <1363043896-16140-1-git-send-email-festevam@gmail.com>
	<1363043896-16140-2-git-send-email-festevam@gmail.com>
	<20130312232410.GA29152@kroah.com>
Date: Tue, 12 Mar 2013 20:41:19 -0300
Message-ID: <CAOMZO5Dv4Oyy7qxQ5eeiwwWOhAv5WbfEp2NcAgvWsykMQar8cA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: imx_v6_v7_defconfig: Select CONFIG_W1_MASTER_MXC
From: Fabio Estevam <festevam@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: zbr@ioremap.net, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Mar 12, 2013 at 8:24 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 11, 2013 at 08:18:16PM -0300, Fabio Estevam wrote:
>> From: Fabio Estevam <fabio.estevam@freescale.com>
>>
>> Select CONFIG_W1_MASTER_MXC.
>
> Why?  Don't tell me what you did, that's obvious, it's the story that is
> needed.
>
> dropped from my queue.

Ok, I will improve the commit log and re-submit it to linux-arm-kernel
list, so that it can go via arm tree and avoid any conflict.
