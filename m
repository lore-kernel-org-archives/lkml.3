Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbaDXM21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:28:27 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:53780 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbaDXM2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:28:23 -0400
Date: Thu, 24 Apr 2014 08:28:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Kefeng Wang <kefeng.wang@linaro.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com
Subject: Re: [PATCH v5 0/3] ahci: add support for hisilicon sata
Message-ID: <20140424122808.GL4781@htj.dyndns.org>
References: <1398256603-20160-1-git-send-email-kefeng.wang@linaro.org>
 <20140423142726.GC4781@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423142726.GC4781@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:27:26AM -0400, Tejun Heo wrote:
> Applied to libata/for-3.16.

Reverted due to build failure.  I was apparently too dependent on
build-bot but what the hell?  This isn't acceptable.

-- 
tejun
