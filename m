Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab3BKVzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 16:55:35 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:38949 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692Ab3BKVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 16:55:34 -0500
X-Auth-Info: Yyy1ykd2o3gCcmlxzvTvWquRSSoa9st8d8BV0fHWJx0=
Date: Mon, 11 Feb 2013 22:55:29 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@list.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] powerpc/5200: Use the gpt* labels to simplify
 mpc5200 dts files
Message-ID: <20130211225529.7ac05eca@crub>
In-Reply-To: <1360310571-31494-2-git-send-email-grant.likely@secretlab.ca>
References: <1360310571-31494-1-git-send-email-grant.likely@secretlab.ca>
	<1360310571-31494-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Feb 2013 08:02:51 +0000
Grant Likely <grant.likely@secretlab.ca> wrote:

> The DTC labels feature allows a dts file to reference a node without
> having to reproduce the entire node hierarchy above it. We can use this
> to simplify the MPC5200 board dts files by referencing the gpt nodes by
> label.
> 
> Cc: Anatolij Gustschin <agust@denx.de>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  arch/powerpc/boot/dts/a3m071.dts    |    6 ++--
>  arch/powerpc/boot/dts/a4m072.dts    |   27 ++++--------------
>  arch/powerpc/boot/dts/cm5200.dts    |    6 ++--
>  arch/powerpc/boot/dts/digsy_mtc.dts |   14 ++--------
>  arch/powerpc/boot/dts/media5200.dts |    6 ++--
>  arch/powerpc/boot/dts/motionpro.dts |   26 ++++++++----------
>  arch/powerpc/boot/dts/mucmc52.dts   |   48 ++++++++------------------------
>  arch/powerpc/boot/dts/o2d.dtsi      |   25 +++++------------
>  arch/powerpc/boot/dts/pcm030.dts    |   48 ++++++--------------------------
>  arch/powerpc/boot/dts/pcm032.dts    |   45 ++++++------------------------
>  arch/powerpc/boot/dts/uc101.dts     |   52 ++++++-----------------------------
>  11 files changed, 69 insertions(+), 234 deletions(-)

Applied, thanks!

Anatolij
