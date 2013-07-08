Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3GHSVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 14:21:54 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:55058 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab3GHSVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 14:21:51 -0400
MIME-Version: 1.0
In-Reply-To: <003301ce78a8$89218fc0$9b64af40$@samsung.com>
References: <CANEJEGunjLOTzyPybRrL7VwkuwDQGJGtwyyg4qogT0A+B2hvjA@mail.gmail.com>
	<CANEJEGvAYxdyq7iK6Y+YcgCFOKhA4+01=m4ofUs3ZE=Mwf7PRw@mail.gmail.com>
	<003301ce78a8$89218fc0$9b64af40$@samsung.com>
Date: Mon, 8 Jul 2013 11:21:50 -0700
X-Google-Sender-Auth: S_CfvVpXULolF6jnyteU7XZa0SE
Message-ID: <CANEJEGsVuWrbXZnjyo1DzFNAOEi7jqL0Yt8LAaEMHR4V2zDGUg@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] iommu/exynos: add missing cache flush for
 removed pagetable entries
From: Grant Grundler <grundler@chromium.org>
To: Cho KyongHo <pullip.cho@samsung.com>
Cc: Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 4, 2013 at 4:20 AM, Cho KyongHo <pullip.cho@samsung.com> wrote:
...
> I am still working on the patch set when I am free.
> Implementation of the updated patch set has been finished but not tested yet.
>
> I will post the patches after simple test :)

Ok - thanks Cho!

If you'd like me to test, please post a "RFC" (request for comment)
version that hasn't yet been tested. You don't have to do everything
yourself. :)

cheers,
grant
