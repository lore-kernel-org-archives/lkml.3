Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaIBEpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 00:45:12 -0400
Received: from plane.gmane.org ([80.91.229.3]:57937 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaIBEpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 00:45:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leon Yu <"Leon Yu"@ccca.nctu.edu.tw>
Subject: Re: [SMP BUG?] the return value of is_smp() is bug?
Date: Tue, 2 Sep 2014 04:40:44 +0000 (UTC)
Message-ID: <lu3hoc$lrl$1@ger.gmane.org>
References: <1409570133-2766-1-git-send-email-long.wanglong@huawei.com>
Reply-To: Leon Yu <chianglungyu@gmail.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 218-161-27-39.hinet-ip.hinet.net
User-Agent: slrn/1.0.1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-01, Wang Long <long.wanglong@huawei.com> wrote:
>
> Hi,all
>
> In kernel 3.17-rc2, when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = y 
> in .config file. the secondary core can not boot.
>
> when i set CONFIG_HAVE_SMP = y and CONFIG_SMP_ON_UP = n in .config file,
> the secondary core can boot.
>
> But this does not happen in kernel 3.10 lts kernel, Whether the 
> CONFIG_SMP_ON_UP is set yes or no ,the secondary core can boot.
>
> Does the meaning of CONFIG_SMP_ON_UP changed or this is a bug in kernel3.17-rc2 ? 

Update qemu to at least 2.0.

qemu of older version fails to smp-boot Linux 3.12+ with CONFIG_SMP_ON_UP
enabled.

-Leon

