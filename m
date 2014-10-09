Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaJIG5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:57:09 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:46848 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJIG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:56:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141008194541.GV868@joshc.qualcomm.com>
References: <1409672443-4289-1-git-send-email-gdjakov@mm-sol.com>
 <1409672443-4289-4-git-send-email-gdjakov@mm-sol.com> <CAP71WjxYibPGBC=x4eA-Lmjg_Mc7cCB20VSvf59C_AW7PYNE=A@mail.gmail.com>
 <20141008194541.GV868@joshc.qualcomm.com>
From: Nicolas Dechesne <nicolas.dechesne@linaro.org>
Date: Thu, 9 Oct 2014 08:56:35 +0200
Message-ID: <CAP71WjxueWji84Ki8eXoTxfW=cyJCB38ivyv-_PXTv7QHPHxDw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ARM: dts: qcom: Add SDHC nodes for APQ8084 platform
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Georgi Djakov <gdjakov@mm-sol.com>, Kumar Gala <galak@codeaurora.org>,
        robh+dt@kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, iivanov@mm-sol.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 9:45 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> This has bitten me more times than I care to admit, but have you checked
> that you've set CONFIG_MMC_BLOCK_MINORS higher than 16?  Perhaps we
> should be doing that in qcom_defconfig if we aren't already.

ouch... i was using multi_v7_defconfig which indeed has:

CONFIG_MMC_BLOCK_MINORS=16

note that you can override the default CONFIG with bootargs with

mmcblk.perdev_minors=32

thanks!
