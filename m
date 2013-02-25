Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736Ab3BYNTA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:19:00 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:64755 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757452Ab3BYNS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <1361797729-19489-1-git-send-email-laurent.navet@gmail.com>
References: <1361797729-19489-1-git-send-email-laurent.navet@gmail.com>
Date: Mon, 25 Feb 2013 14:18:58 +0100
Message-ID: <CAJSP0QWXN=6c5WnVgYKERkg+5fAOfrY6LR2k-P9SPc7UH=Oa-g@mail.gmail.com>
Subject: Re: [PATCH] staging: line6: pod.c: fix checkpatch warning
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        johannes thumshirn <morbidrsa@googlemail.com>,
        devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 2:08 PM, Laurent Navet <laurent.navet@gmail.com> wrote:
>  - WARNING: braces {} are not necessary for single statement blocks
>
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> ---
>  drivers/staging/line6/pod.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
