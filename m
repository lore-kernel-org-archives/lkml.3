Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3COKuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 06:50:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44373 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276Ab3COKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 06:50:11 -0400
Message-ID: <5142FCC9.1030302@ti.com>
Date: Fri, 15 Mar 2013 16:19:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Vishwanathrao Badarkhe, Manish" <manishv.b@ti.com>
CC: <linux-kernel@vger.kernel.org>, <rtc-linux@googlegroups.com>,
        <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <a.zummo@towertech.it>
Subject: Re: [PATCH] rtc: omap: update to devm_* API
References: <1363157464-9962-1-git-send-email-manishv.b@ti.com>
In-Reply-To: <1363157464-9962-1-git-send-email-manishv.b@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2013 12:21 PM, Vishwanathrao Badarkhe, Manish wrote:
> From: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com> 
> 
> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Vishwanathrao Badarkhe, Manish <manishv.b@ti.com>

Tested on DA850 EVM.

Tested-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
