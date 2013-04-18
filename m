Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966151Ab3DRIbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:31:17 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:54737 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966067Ab3DRIbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:31:14 -0400
MIME-Version: 1.0
In-Reply-To: <ede8ee08bb2616c2ed642200e3357367@localhost>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org> <ede8ee08bb2616c2ed642200e3357367@localhost>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 18 Apr 2013 09:30:52 +0100
Message-ID: <CAFEAcA-38=zx-s3NaBAu-yvDNRbt=KcTs-3c1QJR3COB3G1n2A@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
To: Marc Zyngier <maz@misterjones.org>
Cc: PranavkumarSawargaonkar <pranavkumar@linaro.org>,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2013 07:49, Marc Zyngier <maz@misterjones.org> wrote:
> If you need an early console, why not simply wire the 8250 emulation in
> kvmtool to be useable from the MMIO bus? I reckon this would solve your
> problem in a more elegant way...

The other approach I thought of would be something involving
defining a hypercall interface for console I/O, in the same
way that we have hypercalls for "start cpu"/"stop cpu"/etc.
Is there any mileage in considering that approach, or is it
a non-starter?

thanks
-- PMM
