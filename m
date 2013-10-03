Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3JCGW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:22:57 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:53920 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513Ab3JCGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:22:56 -0400
MIME-Version: 1.0
In-Reply-To: <1379462711-6957-1-git-send-email-csd@broadcom.com>
References: <1379462711-6957-1-git-send-email-csd@broadcom.com>
Date: Wed, 2 Oct 2013 23:22:55 -0700
Message-ID: <CAGFynZ8_=0pEZUWmfw4Rwg+PM47=4=w-vdTBpZ9zBxO+RanYsg@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: bcm: Add DEBUG_LL console support
From: Christian Daudt <csd_b@daudt.org>
To: Christian Daudt <csd@broadcom.com>, Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Chris Ball <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 5:05 PM, Christian Daudt <csd@broadcom.com> wrote:
> This patch adds low level debug uart support to Broadcom
>  mobile based SOCs.
>
> Signed-off-by: Christian Daudt <csd@broadcom.com>
>
> Changes from V1:
>  - Switched to use the common 8250 debug introduced in 3.12-rc1
>
Hi Russell,
 Are you okay with v2 of DEBUG_LL support for Broadcom mobile SoC ? If
so, should I submit it through your patchqueue ?

 Thanks,
   csd
