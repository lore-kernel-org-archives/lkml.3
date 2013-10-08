Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3JHFyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 01:54:31 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:57135 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3JHFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 01:54:28 -0400
MIME-Version: 1.0
In-Reply-To: <20131008143307.9270bd3307a0524d89088c2a@ops.dti.ne.jp>
References: <20131008143040.52f36df8edb7ab63224d8433@ops.dti.ne.jp>
	<20131008143307.9270bd3307a0524d89088c2a@ops.dti.ne.jp>
Date: Tue, 8 Oct 2013 14:54:26 +0900
Message-ID: <CANqRtoT0EYcn6U_-Zin7eryiYGwb0C16AyLXtnsQ0Srt1PTG=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: shmobile: emev2: Add clock tree description
 in DT
From: Magnus Damm <magnus.damm@gmail.com>
To: takasi-y@ops.dti.ne.jp
Cc: SH-Linux <linux-sh@vger.kernel.org>, Ben Dooks <ben.dooks@codethink.co.uk>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Mike Turquette <mturquette@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 2:33 PM,  <takasi-y@ops.dti.ne.jp> wrote:
> Add minimum clock tree description to .dts file.
> This provides same set of clocks as current sh-clkfwk version .c
> code does.
>
> Signed-off-by: Takashi Yoshii <takasi-y@ops.dti.ne.jp>
> ---
>  arch/arm/boot/dts/emev2.dtsi | 84 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 84 insertions(+)

Looking good, thanks Yoshii-san!

Acked-by: Magnus Damm <damm@opensource.se>
