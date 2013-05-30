Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab3E3TgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 15:36:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759645Ab3E3TgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 15:36:12 -0400
Date: Thu, 30 May 2013 12:36:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Robert Nelson <robertcnelson@gmail.com>, Johan Hovold <jhovold@gmail.com>,
        Robert Nelson <Robert.Nelson@digikey.com>,
        <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 0/5] rtc-at91rm9200: add shadow interrupt mask
Message-Id: <20130530123609.6e2966a66dd7b131961ed052@linux-foundation.org>
In-Reply-To: <51A704C3.6010109@atmel.com>
References: <1364983415-20298-1-git-send-email-jhovold@gmail.com>
	<1369298335-24597-1-git-send-email-jhovold@gmail.com>
	<20130529133354.dd181c845ee4e96527483345@linux-foundation.org>
	<CAOCHtYiK8Y6iTnb4dWAE+cKHqEta-64gj+PorSFVGBF5wmg1+Q@mail.gmail.com>
	<51A704C3.6010109@atmel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013 09:50:27 +0200 Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> The review of this patch series was in my TODO list for some time...
> 
> Today, I magically took time to review it ;-)
> The patch series is good and I (even if it is too late) here is my:
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> I do not know if the series can be stacked for inclusion in 3.10-rc but 
> the resolution of this bug can help a lot (as Douglas is saying in 
> subsequent email...).

We can do that, but looking through the discussion and changelogs I
can't seem to find a usable description of what impact the bug (and its
fix) have upon end-users.

A nicely packaged description of that impact would help grease the
wheels, please.

