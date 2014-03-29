Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaC2TuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 15:50:13 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42538 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaC2TuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 15:50:11 -0400
Date: Sat, 29 Mar 2014 12:50:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v5 0/9] Use regmap+devm+DT in pm8xxx input drivers
Message-ID: <20140329195007.GA14270@core.coreip.homeip.net>
References: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393958088-1456-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:34:39AM -0800, Stephen Boyd wrote:
> These patches move the pm8xxx input drivers over to use devm_* APIs
> and regmap. This breaks the dependency of these drivers on the pm8xxx
> specific read/write calls and also simplifies the probe code a bit.
> Finally we add devicetree support to these drivers so they can be probed
> on the platforms that are supported upstream.

Applied all (and folded DT binding patches into respective driver
changes).

-- 
Dmitry
