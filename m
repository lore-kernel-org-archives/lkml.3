Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaFEKvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 06:51:33 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:50774 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFEKvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 06:51:32 -0400
Date: Thu, 5 Jun 2014 06:51:27 -0400
From: Matt Porter <mporter@linaro.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, patches@linaro.org, bjorn@kryo.se
Subject: Re: [PATCHv6 2/3] mailbox: Introduce framework for mailbox
Message-ID: <20140605105127.GB32082@beef>
References: <1401733450-5646-1-git-send-email-jaswinder.singh@linaro.org>
 <1401733885-5896-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401733885-5896-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 12:01:24AM +0530, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
>  include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  .../devicetree/bindings/mailbox/mailbox.txt        |  33 ++
>  drivers/mailbox/Makefile                           |   4 +
>  drivers/mailbox/mailbox.c                          | 487 +++++++++++++++++++++
>  include/linux/mailbox_client.h                     |  45 ++
>  include/linux/mailbox_controller.h                 | 121 +++++

Could you please include all the DT maintainers here? It's a generic
binding that needs wider review and an ack. The binding should be
separated as noted below.

>From Documentations/devicetree/bindings/submitting-patches.txt:

I. For patch submitters

  0) Normal patch submission rules from Documentation/SubmittingPatches
     applies.

  1) The Documentation/ portion of the patch should be a separate patch.

  2) Submit the entire series to the devicetree mailinglist at

       devicetree@vger.kernel.org

-Matt
