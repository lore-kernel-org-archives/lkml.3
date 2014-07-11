Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaGKXPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:15:44 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:65027 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaGKXPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <1405116252-53612-1-git-send-email-s-anna@ti.com>
References: <1405116252-53612-1-git-send-email-s-anna@ti.com>
Date: Fri, 11 Jul 2014 16:15:41 -0700
Message-ID: <CAPdLdq=ZnPBQiGVbKOk8G5soP=uPYpT7mEjigpR=W1Hc4btV3g@mail.gmail.com>
Subject: Re: [PATCHv2 0/5] OMAP Mailbox framework adoption & DT support
From: Markus Mayer <markus.mayer@linaro.org>
To: Suman Anna <s-anna@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        Dave Gerlach <d-gerlach@ti.com>, Pavel Machek <pavel@ucw.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 July 2014 15:04, Suman Anna <s-anna@ti.com> wrote:
> Hi,
>
> This is a refresh of the OMAP Mailbox framework adoption & DT support
> series [1], to work with the revised OMAP mailbox DT/hwmod cleanup
> series [2].
>
> The series has one less patch than the previous series, with the patch
> "mailbox/omap: add a custom of_xlate function" squashed into the OMAP
> mailbox framework adaptation patch. The first 3 patches deal with the
> OMAP DT bindings and parse support like previous series, and the last
> 2 patches deal with the mailbox framework adaptation. The testing is
> also done with the updated v8 version of mailbox framework [3] from
> Jassi Brar, no changes are required for the v7 to v8 update.
>
> The AM335 PM suspend series [4] which relies on this series also does
> not require any changes.

May I ask what branch this series is based upon? I tried a number of
branches (3.16-rcX, 3.15, linux-next), and the series won't apply to
any of them (other than patch 1/5, which does apply fine, but that
also contains no code).

Thanks,
-Markus
