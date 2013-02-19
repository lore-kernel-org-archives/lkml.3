Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab3BSTnI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:43:08 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:36058 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933048Ab3BSTnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 14:43:06 -0500
Date: Tue, 19 Feb 2013 20:43:03 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: "Kumar, Anil" <anilkumar.v@ti.com>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com
Subject: Re: [PATCH V2] watchdog: davinci_wdt: update to devm_* API
Message-ID: <20130219194303.GT7867@spo001.leaseweb.com>
References: <1360309170-9672-1-git-send-email-anilkumar.v@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360309170-9672-1-git-send-email-anilkumar.v@ti.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>

Added to linux-watchdog-next.

Kind regards,
Wim.

