Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab3ENSIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:08:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58264 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3ENSIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:08:51 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1368515328-31535-3-git-send-email-draviv@codeaurora.org>
References: <1368515328-31535-1-git-send-email-draviv@codeaurora.org>
	<1368515328-31535-3-git-send-email-draviv@codeaurora.org>
Date: Tue, 14 May 2013 11:08:49 -0700
Message-ID: <CAOesGMij6oKDr0BCRAnmz-r48S5FzzMcU_iyCyCyqkafWsmyNA@mail.gmail.com>
Subject: Re: [PATCH V2 2/9] Documentation: devicetree: Add DT bindings for UFS
 host controller
From: Olof Johansson <olof@lixom.net>
To: Dolev Raviv <draviv@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Sujit Reddy Thumma <sthumma@codeaurora.org>,
        "moderated list:OPEN FIRMWARE AND..." 
	<devicetree-discuss@lists.ozlabs.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 12:08 AM, Dolev Raviv <draviv@codeaurora.org> wrote:
> Compatible list is used in commit 03b1781 but is not documented.
> Add necessary device tree bindings to describe on-chip UFS host
> controllers.
>
> Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
>
> diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> new file mode 100644
> index 0000000..20468b2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
> @@ -0,0 +1,16 @@
> +* Universal Flash Storage (UFS) Host Controller
> +
> +UFSHC nodes are defined to describe on-chip UFS host controllers.
> +Each UFS controller instance should have its own node.
> +
> +Required properties:
> +- compatible        : compatible list, contains "jedec,ufs-1.1"
> +- interrupts        : <interrupt mapping for UFS host controller IRQ>
> +- reg               : <registers mapping>
> +
> +Example:
> +       ufshc@0xfc598000 {
> +               compatible = "jedec,ufs-1.1";

Hmm.

Does jedec really specify the programming interface of this type of
device, register layout and meaning? It seems to be more about the
command set and electrical/connectivity specifications, no?


-Olof
