Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab3GaHNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:13:48 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:38564 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3GaHNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:13:47 -0400
Message-ID: <1375254775.1956.86.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH] drivers: power: reset: add msm restart support
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Abhimanyu Kapur <abhimany@codeaurora.org>
Cc: Anton Vorontsov <anton@enomsg.org>, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
Date: Wed, 31 Jul 2013 10:12:55 +0300
In-Reply-To: <1375229128-32226-1-git-send-email-abhimany@codeaurora.org>
References: <1375229128-32226-1-git-send-email-abhimany@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Tue, 2013-07-30 at 17:05 -0700, Abhimanyu Kapur wrote:
> Add support for restart and poweroff functionality present on MSM
> chipsets with the MPM2 ps-hold hardware.
> 
> Signed-off-by: Abhimanyu Kapur <abhimany@codeaurora.org>
> ---
>  .../bindings/power_supply/msm-poweroff.txt         | 17 +++++
>  drivers/power/reset/Kconfig                        |  6 ++
>  drivers/power/reset/Makefile                       |  1 +
>  drivers/power/reset/msm-poweroff.c                 | 75 ++++++++++++++++++++++
>  4 files changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power_supply/msm-poweroff.txt
>  create mode 100644 drivers/power/reset/msm-poweroff.c

Thank you, Could you next time add version in the subject line, 
like "PATH v2", it is easier to track changes.

Tested-by: Ivan T. Ivanov <iivanov@mm-sol.com>

Regards,
Ivan

