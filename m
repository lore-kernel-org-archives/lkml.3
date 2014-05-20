Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaETTaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:30:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbaETTaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:30:05 -0400
Date: Tue, 20 May 2014 21:30:01 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Harald Brinkmann <hbrinkmann@braincalibration.de>
cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] HID: quirk for Saitek RAT7 and MMO7 mices' mode
 button
In-Reply-To: <537B9EB0.60603@braincalibration.de>
Message-ID: <alpine.LNX.2.00.1405202129510.19150@pobox.suse.cz>
References: <537B9EB0.60603@braincalibration.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2014, Harald Brinkmann wrote:

> Some saitek mice implement a tristate button (for switching button
> mappings in the original driver) by keeping one of three (non-physical)
> buttons constantly pressed.
> This breaks X and probably other userspace software.
> This patch implements a quirk for the R.A.T.7 and M.M.O.7, tracking
> the mode and generating presses of a single button if it changes.
> Also the missing release event is generated instantly.
> 
> Signed-off-by: Harald Brinkmann <hbrinkmann@braincalibration.de>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
