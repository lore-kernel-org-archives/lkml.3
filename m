Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3EWJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 05:10:46 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:35887 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757781Ab3EWJKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 05:10:44 -0400
MIME-Version: 1.0
In-Reply-To: <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com> <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 23 May 2013 14:40:23 +0530
Message-ID: <CA+V-a8vXkH-N=1cCsj2KtXz6Jz3UprNrrbA9w1TN-NrBRHuAog@mail.gmail.com>
Subject: Re: [PATCH 2/6] ARM: davinci: dm365 evm: remove init_enable from
 ths7303 pdata
To: Sekhar Nori <nsekhar@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sekhar,

On Wed, May 15, 2013 at 5:27 PM, Lad Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>
> remove init_enable from ths7303 pdata as it is no longer exists.
>
Can you please ack this patch, as this patch is intended to go via media tree.

Regards,
--Prabhakar Lad
