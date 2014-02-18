Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaBRVcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:32:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:56463 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaBRVcn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:32:43 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
Date: Tue, 18 Feb 2014 15:32:37 -0600
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, s-anna@ti.com,
        tony@atomide.com, omar.ramirez@copitl.com, loic.pallardy@st.com,
        lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, rafael.j.wysocki@intel.com,
        Jassi Brar <jaswinder.singh@linaro.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <95FE2F33-B9C5-4F24-B639-3F1D42EFD1E1@codeaurora.org>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org> <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15, 2014, at 12:25 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:

> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).
> 
> Client driver developers should have a look at
> include/linux/mailbox_client.h to understand the part of
> the API exposed to client drivers.
> Similarly controller driver developers should have a look
> at include/linux/mailbox_controller.h
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
> drivers/mailbox/Makefile           |   4 +
> drivers/mailbox/mailbox.c          | 534 +++++++++++++++++++++++++++++++++++++
> include/linux/mailbox.h            |  17 ++
> include/linux/mailbox_client.h     |  87 ++++++
> include/linux/mailbox_controller.h | 102 +++++++
> 5 files changed, 744 insertions(+)
> create mode 100644 drivers/mailbox/mailbox.c
> create mode 100644 include/linux/mailbox.h
> create mode 100644 include/linux/mailbox_client.h
> create mode 100644 include/linux/mailbox_controller.h

What’s the intent of trying to provide a unified interface here?  I’m trying to understand what benefit we are going for, I get possibly wanting something to reduce duplication in drivers (help functions, library, etc).  But do we really see benefit in a common interface for clients?

Are we really going to mix a OMAP mailbox controller with a client developed for some other SoC vendor?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

