Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaBOTBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:01:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbaBOTBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:01:43 -0500
Date: Sat, 15 Feb 2014 11:03:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, s-anna@ti.com, tony@atomide.com,
        omar.ramirez@copitl.com, loic.pallardy@st.com, lftan.linux@gmail.com,
        slapdau@yahoo.com.au, courtney.cavin@sonymobile.com,
        rafael.j.wysocki@intel.com, Jassi Brar <jaswinder.singh@linaro.org>
Subject: Re: [PATCHv3 2/6] mailbox: Introduce a new common API
Message-ID: <20140215190303.GA1801@kroah.com>
References: <1392488526-17715-1-git-send-email-jaswinder.singh@linaro.org>
 <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392488727-17981-1-git-send-email-jaswinder.singh@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 11:55:27PM +0530, Jassi Brar wrote:
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
>  drivers/mailbox/Makefile           |   4 +
>  drivers/mailbox/mailbox.c          | 534 +++++++++++++++++++++++++++++++++++++
>  include/linux/mailbox.h            |  17 ++
>  include/linux/mailbox_client.h     |  87 ++++++
>  include/linux/mailbox_controller.h | 102 +++++++
>  5 files changed, 744 insertions(+)
>  create mode 100644 drivers/mailbox/mailbox.c
>  create mode 100644 include/linux/mailbox.h
>  create mode 100644 include/linux/mailbox_client.h
>  create mode 100644 include/linux/mailbox_controller.h

Did you forget a Kconfig file here?  How can this code be built?

