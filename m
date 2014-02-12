Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaBLUFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 15:05:03 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37276 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBLUE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 15:04:59 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:3587:b577:ce10:fe39]
In-Reply-To: <1392173024-11567-1-git-send-email-acourbot@nvidia.com>
References: <52FAD4C2.80803@nvidia.com>
	<1392173024-11567-1-git-send-email-acourbot@nvidia.com>
Date: Wed, 12 Feb 2014 12:04:58 -0800
Message-ID: <CAOesGMhk_chCYJ0Qpj0Sju6k7OQJ+c1_VnfZNTOfw2WPHPyQ4A@mail.gmail.com>
Subject: Re: [PATCH v3] ARM: tegra: cpuidle: use firmware for power down
From: Olof Johansson <olof@lixom.net>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 6:43 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> Attempt to invoke the prepare_idle() and do_idle() firmware calls
> to power down a CPU so an underlying firmware gets informed of
> the idle operation and performs it by itself if designed in such a way.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
