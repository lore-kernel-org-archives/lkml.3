Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3LSVPi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 16:15:38 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:37651 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755747Ab3LSVPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 16:15:37 -0500
X-Auth-Info: QcRhVuxGp2H+MrOcl+gKnpN7C4JcvVgeRS+BeQ2DbW8=
Date: Thu, 19 Dec 2013 22:15:33 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: remove CONFIG_COMMON_CLK_DEBUG
Message-ID: <20131219211533.GT8064@book.gsilab.sittig.org>
Mail-Followup-To: Mike Turquette <mturquette@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1387431800-10092-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387431800-10092-1-git-send-email-mturquette@linaro.org>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 21:43 -0800, Mike Turquette wrote:
> 
> Populate ${DEBUGS_MOUNT_POINT}/clk if CONFIG_DEBUG_FS is set. This
> eliminates the extra (annoying) step of enabling the config option
> manually.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>

Yes, please!  The debugfs information is just too useful to hide
behind another option that requires manual enabling. :)


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
