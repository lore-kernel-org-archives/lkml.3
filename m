Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3IQInK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:43:10 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:64610 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3IQInH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:43:07 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 12/28] arm64: use early_init_dt_scan
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <1379372965-22359-13-git-send-email-robherring2@gmail.com>
Date: Tue, 17 Sep 2013 09:43:01 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <32BCA673-44E0-4358-BBE4-B42F3CA34192@arm.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com> <1379372965-22359-13-git-send-email-robherring2@gmail.com>
To: Rob Herring <robherring2@gmail.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 Sep 2013, at 00:09, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Convert arm64 to use new early_init_dt_scan function.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

