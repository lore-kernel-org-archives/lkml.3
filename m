Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab3IRGP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 02:15:58 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:61215 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3IRGNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 02:13:32 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 20/28] arm64: set initrd_start/initrd_end for fdt scan
To: Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <8639E68F-4CCB-4E34-82BF-18EDA98BB978@arm.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-21-git-send-email-robherring2@gmail.com> <8639E68F-4CCB-4E34-82BF-18EDA98BB978@arm.com>
Date: Tue, 17 Sep 2013 22:36:51 -0500
Message-Id: <20130918033651.3FA9AC42CA8@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Sep 2013 09:50:04 +0100, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On 17 Sep 2013, at 00:09, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> > 
> > In order to unify the initrd scanning for DT across architectures, make
> > arm64 use initrd_start and initrd_end instead of the physical addresses.
> > 
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Grant Likely <grant.likely@linaro.org>

