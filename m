Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3DDJUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:20:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60356 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430Ab3DDJUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:20:23 -0400
Message-ID: <515D45CD.6000407@ti.com>
Date: Thu, 4 Apr 2013 14:50:13 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 2/2] ARM: davinci: dm355 EVM: add support for VPBE
 display
References: <1364908504-14232-1-git-send-email-prabhakar.csengg@gmail.com> <1364908504-14232-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364908504-14232-3-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 6:45 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add support for V4L2 video display to DM355 EVM.
> Support for SD modes is provided, along with Composite
> output
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Looks good. Since you mentioned that you will take this through media
tree to manage driver dependencies, please add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
