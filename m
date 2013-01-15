Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3AOG2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:28:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60212 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab3AOG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:28:13 -0500
Date: Mon, 14 Jan 2013 22:28:13 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-mmc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Will Newton <will.newton@imgtec.com>, Chris Ball <cjb@laptop.org>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4 5/5] mmc: dw_mmc: Remove DW_MCI_QUIRK_NO_WRITE_PROTECT
Message-ID: <20130115062813.GD20105@quad.lixom.net>
References: <1357842269-15062-1-git-send-email-dianders@chromium.org>
 <1357923834-31641-1-git-send-email-dianders@chromium.org>
 <1357923834-31641-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357923834-31641-5-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 09:03:54AM -0800, Doug Anderson wrote:
> The original quirk was added in the change 'mmc: dw_mmc: add quirk to
> indicate missing write protect line'.  The original quirk was added at
> a controller level even though each slot has its own write protect (so
> the quirk should be at the slot level).  A recent change (mmc: dw_mmc:
> Add "disable-wp" device tree property) added a slot-level quirk and
> support for the quirk directly to dw_mmc.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Olof Johansson <olof@lixom.net>
