Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbaEGGjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:39:04 -0400
Received: from smtp-out-029.synserver.de ([212.40.185.29]:1042 "EHLO
	smtp-out-016.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750969AbaEGGjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:39:02 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13621
Message-ID: <5369D4FF.1070004@metafoo.de>
Date: Wed, 07 May 2014 08:38:55 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Christopher Freeman <cfreeman@nvidia.com>
CC: ldewangan@nvidia.com, swarren@nvidia.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] Tegra DMA residue improvements
References: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
In-Reply-To: <1399411343-12222-1-git-send-email-cfreeman@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 11:22 PM, Christopher Freeman wrote:
> A collection of patches to improve Tegra's DMA residual reporting
>

It would be nice if you could, while you are at it, also implement the 
device_salve_caps callback. This will allow clients to automatically pick up 
things like the supported granularity and other things.

- Lars
