Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3ENKyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:54:15 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39403 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3ENKyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:54:13 -0400
MIME-Version: 1.0
In-Reply-To: <1368518791-26332-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368518791-26332-1-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 14 May 2013 16:23:50 +0530
Message-ID: <CA+V-a8uakxH795-FKmE4arWZZHRracVTuSnoEA7SgOLaCkfrLg@mail.gmail.com>
Subject: Re: [PATCH v2] media: i2c: tvp514x: add OF support
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On Tue, May 14, 2013 at 1:36 PM, Lad Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> add OF support for the tvp514x driver. Alongside this patch
> removes unnecessary header file inclusion and sorts them alphabetically.
>
Ahh just noticed it now, I'll just rebase and resend this patch on [1]
so that slab.h can also be removed.

[1] https://patchwork.kernel.org/patch/2539411/

Regards,
--Prabhakar Lad
