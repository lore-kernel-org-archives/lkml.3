Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaABSNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:13:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53025 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaABSNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:13:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/7] Allow MSM DT platforms to be built multi-platform
Date: Thu, 2 Jan 2014 19:13:25 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>, arm@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        David Brown <davidb@codeaurora.org>, Chris Ball <cjb@laptop.org>
References: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1388438133-431-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401021913.25920.arnd@arndb.de>
X-Provags-ID: V02:K0:eB6KgUuQf9urQloKKTq0rFJAG6Ly40PCKQBo5UxK2cD
 7gaOTG56fDqvrZ8n4xY2REwBIpRLKxZlzQrD0if3OBxRAscYGG
 kN09+O9QTZkV5SUzwrSlqv3l3XAXkqo6W3SvAmSf4Vi0MYV64N
 cPt4/wPFJdkic5OXq6dbA6U0ubj/zYEaY3SrOaIAzZr32g7jI5
 gZtV5GIBGY4Zyz0td89HdbR33NvoK6F1Q/vA5rHJ2s/MRFKaO9
 VM8CAa386/36nw3+vOgj2UBHTFEFLZZ5m1fXDLlQCZEWUGWnWf
 lgxiZJ7NAB76DmzajmNy3BLxTCyoirTZIKoNQ0eY4Sjb7eyrTZ
 Bt6O0MfUlr9XGxHboSA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 December 2013, Stephen Boyd wrote:
> These patches allow the DT based MSM platforms to be built as part of the
> multi-platform kernel. I need acks from Chris Ball on the mmc patch and
> Rob/Dave on the drm patch. I dropped Arnd's ack on patch 6 because I've
> rebased that patch on top of the patchset David sent out (which this is in
> reply to). The rebase was fairly minor and the new patch for drm/msm is
> trivial. Please consider for v3.14.

Just for the record, I'm definitely happy with the way this is turning out,
don't see my question on the serial driver as a NAK. I assume we will apply
the patches for 3.14, but I first want to have a better understanding on
where we are with the stuff that is already queued up for 3.14.

	Arnd
