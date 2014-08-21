Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaHULPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:15:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbaHULPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:15:16 -0400
Message-ID: <53F5D4C0.8020607@redhat.com>
Date: Thu, 21 Aug 2014 13:15:12 +0200
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
CC: Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 09/13] csiostor: Remove superfluous call to pci_disable_msix()
References: <cover.1408335523.git.agordeev@redhat.com> <32f317b013341f51bab2a4869108772781862da6.1408335523.git.agordeev@redhat.com>
In-Reply-To: <32f317b013341f51bab2a4869108772781862da6.1408335523.git.agordeev@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> There is no need to call pci_disable_msix() in case
> the previous call to pci_enable_msix() failed

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

