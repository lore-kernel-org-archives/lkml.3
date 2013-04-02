Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273Ab3DBXUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:20:17 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:41028 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760177Ab3DBXUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:20:15 -0400
Date: Wed, 3 Apr 2013 01:20:08 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 5/7] r8169: add a new chip for RTL8111G
Message-ID: <20130402232008.GB16612@electric-eye.fr.zoreil.com>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
 <1364824539-4156-5-git-send-email-hayeswang@realtek.com>
 <20130401222235.GB19335@electric-eye.fr.zoreil.com>
 <2808A1ABA9A5470C8CB9534309588984@realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2808A1ABA9A5470C8CB9534309588984@realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hayeswang <hayeswang@realtek.com> :
> Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> > There is close to zero added value for this stuff in the kernel.
> > You may as well move it completely into the firmware.
> 
> Do you mean all of the phy settings ? I have checked these settings with
> our hw engineers. These are not firmware. 

Undocumented configuration data which is subject to change over time ?

No one outside of Realtek can make any sense of this opaque pile of data.
There is no point in me or anybody else rubber stamping it for inclusion.

-- 
Ueimor
