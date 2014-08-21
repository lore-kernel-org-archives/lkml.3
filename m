Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbaHUS53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:57:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52616 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaHUS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:57:27 -0400
Date: Thu, 21 Aug 2014 11:57:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Harini Katakam <harinik@xilinx.com>
Cc: wim@iguana.be, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        michals@xilinx.com, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, harinikatakamlinux@gmail.com,
        svemula@xilinx.com, anirudh@xilinx.com
Subject: Re: [PATCH v4 1/2] watchdog: Add Cadence WDT driver
Message-ID: <20140821185722.GA17481@roeck-us.net>
References: <1406788855-19074-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406788855-19074-1-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 12:10:54PM +0530, Harini Katakam wrote:
> Add Cadence WDT driver. This is used by Xilinx Zynq.
> 
> Signed-off-by: Harini Katakam <harinik@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
