Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab3IQIuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:50:12 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43786 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab3IQIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:50:09 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 20/28] arm64: set initrd_start/initrd_end for fdt scan
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1379372965-22359-21-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 09:50:04 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8639E68F-4CCB-4E34-82BF-18EDA98BB978@arm.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-21-git-send-email-robherring2@gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Sep 2013, at 00:09, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> In order to unify the initrd scanning for DT across architectures, make
> arm64 use initrd_start and initrd_end instead of the physical addresses.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

