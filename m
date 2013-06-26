Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3FZXMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:12:49 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:50676 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3FZXMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:12:47 -0400
MIME-Version: 1.0
In-Reply-To: <1372264261-17442-8-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com> <1372264261-17442-8-git-send-email-liuj97@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Jun 2013 17:12:26 -0600
Message-ID: <CAErSpo4QPz=Tfd=0kqTPchvkLKwcBVdWjsk89a+VU-yNzS-CSw@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] ACPI: simplify dock driver with new interfaces
To: Jiang Liu <liuj97@gmail.com>
Cc: "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:30 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
>
> Use new helper functions to simpilify ACPI dock driver.

s/simpilify/simplify/

I noticed this spelling error in other places, too, some in subject lines.

Very nice cleanups overall.

> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Jiang Liu <liuj97@gmail.com>
> Cc: Len Brown <lenb@kernel.org>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/acpi/dock.c | 122 ++++++----------------------------------------------
>  1 file changed, 12 insertions(+), 110 deletions(-)
