Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbaGPSwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:52:53 -0400
Received: from smtp-out-145.synserver.de ([212.40.185.145]:1044 "EHLO
	smtp-out-145.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaGPSwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:52:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11818
Message-ID: <53C6C9F5.5070204@metafoo.de>
Date: Wed, 16 Jul 2014 20:52:37 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: jz4740: Fix GPL v2 license string typo
References: <20140715232438.24028.90309.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140715232438.24028.90309.stgit@bhelgaas-glaptop.roam.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 01:24 AM, Bjorn Helgaas wrote:
> Per license_is_gpl_compatible(), the MODULE_LICENSE() string for GPL v2 is
> "GPL v2", not "GPLv2".  Use "GPL v2" so this module doesn't taint the
> kernel.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Thanks.
