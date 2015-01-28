Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbbA2BVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:21:49 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57722 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbbA2BVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:21:46 -0500
MIME-Version: 1.0
In-Reply-To: <1422424187-19059-1-git-send-email-pramod.gurav@smartplayin.com>
References: <1422424187-19059-1-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 28 Jan 2015 08:13:54 +0100
Message-ID: <CACna6rw5uqB=KZjcao8kLvQ0rgCuqOo7KkyReMF3ZoT0ZH4U=Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] ssb: Fix Sparse error in main
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, John Linville <linville@tuxdriver.com>,
        Michael Buesch <m@bues.ch>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2015 at 06:49, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> This change fixes below sparse error:
> drivers/ssb/main.c:94:16: warning: symbol 'ssb_sdio_func_to_bus'
> was not declared. Should it be static?

Seems like it was never used. Looks OK.
