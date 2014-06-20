Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934852AbaFTI0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 04:26:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42530 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932937AbaFTI0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 04:26:22 -0400
Date: Fri, 20 Jun 2014 09:25:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: add the ability to hook the fault code
Message-ID: <20140620082556.GD25104@arm.com>
References: <1403175296-25181-1-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403175296-25181-1-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 11:54:56AM +0100, Neil Zhang wrote:
> Add the ability to hook the fault code for future use.

Do you have a user for this in the kernel tree? I'd rather add the hook with
the first user, if it doesn't exist already.

Will
