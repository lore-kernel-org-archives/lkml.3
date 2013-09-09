Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab3IIEqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:46:33 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50683 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3IIEqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:46:32 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <522D5299.9020809@jp.fujitsu.com>
Date: Mon, 09 Sep 2013 13:46:17 +0900
From: Takao Indoh <indou.takao@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: bhe@redhat.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, joro@8bytes.org, alex.williamson@redhat.com,
        kexec@lists.infradead.org
Subject: Re: [PATCH] intel-iommu: Quiesce devices before disabling IOMMU
References: <1377069354-5056-1-git-send-email-indou.takao@jp.fujitsu.com> <20130908114752.GA24572@dhcp-16-252.nay.redhat.com> <522D4E8A.8010507@jp.fujitsu.com>
In-Reply-To: <522D4E8A.8010507@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/09/09 13:28), Takao Indoh wrote:
>> BTW, what's the status of Alex's PCI patchset which this patch depends
>> on?
> 
> It is merged to Bjorn's tree, will be in v3.12.

This was wrong. Alex's patchset is already in Linus tree, v3.11.

Thanks,
Takao Indoh


