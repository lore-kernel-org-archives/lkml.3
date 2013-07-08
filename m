Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab3GHS3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:29:25 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35245 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3GHS3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <CANEJEGsVuWrbXZnjyo1DzFNAOEi7jqL0Yt8LAaEMHR4V2zDGUg@mail.gmail.com>
References: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
	<CANEJEGvAYxdyq7iK6Y+YcgCFOKhA4+01=m4ofUs3ZE=Mwf7PRw@mail.gmail.com>
	<003301ce78a8$89218fc0$9b64af40$@samsung.com>
	<CANEJEGsVuWrbXZnjyo1DzFNAOEi7jqL0Yt8LAaEMHR4V2zDGUg@mail.gmail.com>
Date: Mon, 8 Jul 2013 11:29:20 -0700
X-Google-Sender-Auth: 6U5or_p9fqnKXkVkJiioblfoY_c
Message-ID: <CANEJEGtN7G6kTM79QKA5=CTwe4i1EqNdNvmHCN830gUBX=4Pyw@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] iommu/exynos: add missing cache flush for
 removed pagetable entries
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Joerg Roedel <joro@8bytes.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 11:21 AM, Grant Grundler <grundler@chromium.org> wrote:
> On Thu, Jul 4, 2013 at 4:20 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
> ...
>> I am still working on the patch set when I am free.
>> Implementation of the updated patch set has been finished but not tested yet.
>>
>> I will post the patches after simple test :)
>
> Ok - thanks Cho!
>
> If you'd like me to test, please post a "RFC" (request for comment)
> version that hasn't yet been tested. You don't have to do everything
> yourself. :)

Nevermind...I'm catching on email in reverse and see that you've
already posted the patches!

I'll try to test those today. :)

thanks!
grant
