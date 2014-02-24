Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaBXPIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:08:54 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:63291 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaBXPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:08:52 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.86.48]
In-Reply-To: <000201ce9734$ca5e8a10$5f1b9e30$@samsung.com>
References: <000201ce9734$ca5e8a10$5f1b9e30$@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 24 Feb 2014 17:08:30 +0200
Message-ID: <CAK=WgbZxAVRxwY46hYczjpBNHmZ36x+xsu-kuZJu=LgvXD1vHw@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: ste_modem: Staticize local symbols
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 11:20 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> These local symbols are used only in this file.
> Fix the following sparse warnings:
>
> drivers/remoteproc/ste_modem_rproc.c:167:27: warning: symbol 'sproc_fw_ops' was not declared. Should it be static?
> drivers/remoteproc/ste_modem_rproc.c:196:25: warning: symbol 'sproc_dev_cb' was not declared. Should it be static?
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied and pushed to remoteproc-next, thanks!
