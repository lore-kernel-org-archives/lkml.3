Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbaAHBlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:41:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097AbaAHBk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:40:57 -0500
MIME-Version: 1.0
In-Reply-To: <52C80AA4.7070008@acm.org>
References: <52C80A50.3000602@acm.org>
	<52C80AA4.7070008@acm.org>
Date: Wed, 8 Jan 2014 09:40:56 +0800
Message-ID: <CACVXFVNfu6JigB4-PXxjFF=GEUOuPK8wNY-20uS5d5hEWxURpg@mail.gmail.com>
Subject: Re: [PATCH 2/3] firmware loader: Add sparse annotation
From: Ming Lei <ming.lei@canonical.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 4, 2014 at 9:20 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> Avoid that sparse reports the following warning on __fw_free_buf():
>
> drivers/base/firmware_class.c:230:9: warning: context imbalance in '__fw_free_buf' - unexpected unlock
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Ming Lei <ming.lei@canonical.com>

Bart, thanks.

Acked-by: Ming Lei <ming.lei@canonical.com>


Thanks,
--
Ming Lei
