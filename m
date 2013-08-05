Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab3HEQYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:24:21 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:64275 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3HEQYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:24:17 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Andrii Tseglytskyi <andrii.tseglytskyi@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v1 0/2] PM / AVS: interrupt handling fixes
References: <1373637123-1152-1-git-send-email-andrii.tseglytskyi@ti.com>
Date: Mon, 05 Aug 2013 09:24:13 -0700
In-Reply-To: <1373637123-1152-1-git-send-email-andrii.tseglytskyi@ti.com>
	(Andrii Tseglytskyi's message of "Fri, 12 Jul 2013 16:52:01 +0300")
Message-ID: <87y58ggl76.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrii Tseglytskyi <andrii.tseglytskyi@ti.com> writes:

> Hi Kevin,
>
> Could you please take a look to the following patch series.
> It consists of two patches, which are needed for proper
> SmartReflex Interrupt handling.

Thanks.

It doesn't appear that these are regression fixes, so I'm queuing for
v3.12.  

Kevin (apologies for the major lag, just returning from some time off...)
