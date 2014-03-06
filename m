Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaCFAer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:34:47 -0500
Received: from mail-yh0-f41.google.com ([209.85.213.41]:52760 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCFAep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:34:45 -0500
MIME-Version: 1.0
In-Reply-To: <53176D59.3030602@canonical.com>
References: <1393429360-4344-1-git-send-email-clancy.kieran@gmail.com>
 <1393596748-3656-1-git-send-email-clancy.kieran@gmail.com> <53176D59.3030602@canonical.com>
From: Kieran Clancy <clancy.kieran@gmail.com>
Date: Thu, 6 Mar 2014 11:04:14 +1030
Message-ID: <CAGf84Q+7=abgk78WuhNWdy+3kgXma1fHj6OPk9ytQ4kFzcoFJA@mail.gmail.com>
Subject: Re: [PATCH v2] ACPI / EC: Clear stale EC events on Samsung systems
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Guang <lig.fnst@cn.fujitsu.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Juan Manuel Cabo <juanmanuel.cabo@gmail.com>,
        Dennis Jansen <dennis.jansen@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 5:00 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> I notice there was no cc to stable.  Were you also planning on
> submitting this for inclusion in the upstream stable kernels?

I don't really know the process for stable kernels
(Documentation/SubmittingPatches mentions nothing), but of course I'd
like it included if possible.

Rafael, is it a separate process to get this in the stable tree or
will it naturally happen after being merged into the mainline?

Thanks,
Kieran
