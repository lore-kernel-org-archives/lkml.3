Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761376Ab3DBIeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:34:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42588 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760516Ab3DBIeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:34:01 -0400
Message-ID: <515A97DE.1080403@ti.com>
Date: Tue, 2 Apr 2013 14:03:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Philip Avinash <avinashphilip@ti.com>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <prakash.pm@ti.com>,
        <jacmet@sunsite.dk>
Subject: Re: [PATCH v3 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1364197789-16783-1-git-send-email-avinashphilip@ti.com> <1364197789-16783-4-git-send-email-avinashphilip@ti.com>
In-Reply-To: <1364197789-16783-4-git-send-email-avinashphilip@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/2013 1:19 PM, Philip Avinash wrote:
> Add da850 EHRPWM & ECAP DT node.
> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
> clock.

This looks fine to me but I will wait for the bindings to get accepted
before taking this one.

Thanks,
Sekhar
