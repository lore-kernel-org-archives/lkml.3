Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3J2JbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 05:31:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:37718 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753659Ab3J2JbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 05:31:18 -0400
Date: Tue, 29 Oct 2013 10:31:14 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        sachin.kamat@linaro.org, dan.j.williams@intel.com,
        vinod.koul@intel.com
Subject: Re: [PATCH 1/2] dma: mv_xor: Remove unneeded NULL address check
Message-ID: <20131029103114.45355c97@skate>
In-Reply-To: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.9.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Ezequiel Garcia,

On Mon, 28 Oct 2013 19:54:14 -0300, Ezequiel Garcia wrote:
> This mmio address is checked at probe-time, which makes this test
> redundant. Let's just remove it.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
