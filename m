Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbaBXPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:08:21 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:48263 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbaBXPIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:08:19 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.86.48]
In-Reply-To: <1376471493-22215-25-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr> <1376471493-22215-25-git-send-email-Julia.Lawall@lip6.fr>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 24 Feb 2014 17:07:57 +0200
Message-ID: <CAK=WgbZum43gEHQ56EYX-WzsEtpGRJyWaZg-tUseuMxkuP9qxw@mail.gmail.com>
Subject: Re: [PATCH 24/29] drivers/remoteproc/da8xx_remoteproc.c: simplify use
 of devm_ioremap_resource
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:11 PM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
>
...
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied and pushed to remoteproc-next, thanks!
