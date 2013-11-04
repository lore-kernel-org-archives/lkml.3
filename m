Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3KDJLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:11:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33498 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab3KDJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:11:50 -0500
Date: Mon, 4 Nov 2013 09:11:47 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] extcon: arizona: Fix race with microphone
	detection and removal
Message-ID: <20131104091147.GB30879@opensource.wolfsonmicro.com>
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1382890752-30970-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <5276EC68.1040505@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5276EC68.1040505@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 09:38:00AM +0900, Chanwoo Choi wrote:
> This patch has build break as below log:
> 
> drivers/extcon/extcon-arizona.c: In function ‘arizona_micd_detect’:
> drivers/extcon/extcon-arizona.c:776:11: error: ‘struct arizona_extcon_info’ has no member named ‘cable’
> 
> The arizona_extcon_info structure hasn't included 'cable' field.

Apologies, must have been accidentally being added by another
patch in my tree. I will sort that out and resend.

Thanks,
Charles
