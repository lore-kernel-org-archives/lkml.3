Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760176Ab3CIBGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 20:06:45 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55845 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3CIBGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 20:06:43 -0500
X-IronPort-AV: E=Sophos;i="4.84,811,1355126400"; 
   d="scan'208";a="28061577"
Message-ID: <513A8B22.5030008@codeaurora.org>
Date: Fri, 08 Mar 2013 17:06:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-4-git-send-email-sboyd@codeaurora.org> <20130308004011.GD11806@atomide.com> <51393B59.3070200@codeaurora.org> <20130308180730.GE11806@atomide.com> <513A2B20.30805@codeaurora.org> <20130308194802.GG11806@atomide.com> <513A40EF.8050403@codeaurora.org> <20130308200811.GJ11806@atomide.com> <513A4774.3040605@codeaurora.org> <20130308202947.GK11806@atomide.com>
In-Reply-To: <20130308202947.GK11806@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/13 12:29, Tony Lindgren wrote:
> Applying that does not seem to help, but you might want to get vexpress
> running anyways for some multiplatform sanity checks.
>
> I just built and installed qemu-linaro from their git, then ran the
> command above. Looks like stock qemu does not work for vexpress for some
> reason. You can probably use a dummy initrd and rootfs to debug this
> though :)

So my patchset didn't break qemu?

>
> More info on qemu-linaro at:
>
> https://launchpad.net/qemu-linaro

Thanks for the link.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

