Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaG2LBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:01:00 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36098 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbaG2LA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:00:59 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.8.40]
In-Reply-To: <1404836521-59637-3-git-send-email-s-anna@ti.com>
References: <1404836521-59637-1-git-send-email-s-anna@ti.com> <1404836521-59637-3-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 29 Jul 2014 14:00:38 +0300
Message-ID: <CAK=WgbY-WmcJdnLHDf1CSkJqNBUeUMPTLcEZyLGKnECbxH1OAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] remoteproc: add support to handle internal memories
To: Suman Anna <s-anna@ti.com>
Cc: Dave Gerlach <d-gerlach@ti.com>,
        =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Robert Tivy <rtivy@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

On Tue, Jul 8, 2014 at 7:22 PM, Suman Anna <s-anna@ti.com> wrote:
> A remote processor may need to load certain firmware sections into
> internal memories (eg: RAM at L1 or L2 levels) for performance or
> other reasons.

Can you please provide as much details as you can about the scenario
you need this for? what hardware, what sections, which specific
memory, what's the use case, numbers, sizes, everything.

I'd like to better understand the use case please.

Thanks,
Ohad.
