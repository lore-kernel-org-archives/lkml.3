Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaEMTEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:04:39 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43560 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaEMTEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:04:32 -0400
Date: Tue, 13 May 2014 15:04:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Kefeng Wang <kefeng.wang@linaro.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com, xuwei5@hisilicon.com
Subject: Re: [PATCH v6 3/3] ahci: add support for Hisilicon sata
Message-ID: <20140513190427.GA28815@htj.dyndns.org>
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org>
 <1398416351-30567-4-git-send-email-kefeng.wang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398416351-30567-4-git-send-email-kefeng.wang@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:59:11PM +0800, Kefeng Wang wrote:
> The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
> and it is compliant with the ahci 1.3 and sata 3.0 specification.
> 
> There is a wrong bit in HOST_CAP of hip04 sata controller, which
> enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
> disable it.
> 
> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>

Doesn't apply to libata/for-3.16.  Please refresh.

Thanks.

-- 
tejun
