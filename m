Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3CEHYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:24:05 -0500
Received: from linux-sh.org ([111.68.239.195]:47761 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab3CEHYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:24:03 -0500
Date: Tue, 5 Mar 2013 16:23:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 20/24] rtc: rtc-sh: use module_platform_driver_probe()
Message-ID: <20130305072336.GE14275@linux-sh.org>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
 <014d01ce18af$0c473620$24d5a260$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <014d01ce18af$0c473620$24d5a260$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 05:05:34PM +0900, Jingoo Han wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Not sure I see the point, but:

Acked-by: Paul Mundt <lethal@linux-sh.org>
