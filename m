Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbaHHPpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:45:50 -0400
Received: from yes.iam.tj ([109.74.197.121]:59410 "EHLO iam.tj"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756163AbaHHPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:45:48 -0400
Message-ID: <53E4F0AA.6000404@iam.tj>
Date: Fri, 08 Aug 2014 16:45:46 +0100
From: TJ <linux@iam.tj>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org >> linux-kernel" 
	<linux-kernel@vger.kernel.org>
CC: linux-pci@vger.kernel.org
Subject: Re: Regression: pci=realloc fails to modify bridge windows, causing
 devices to fail BAR allocation
References: <53D9FADA.6020304@iam.tj>
In-Reply-To: <53D9FADA.6020304@iam.tj>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/14 09:14, TJ wrote:
> See https://bugzilla.kernel.org/show_bug.cgi?id=81431
>
> Summary:
>
> Up until v3.15.7 booting with "pci=realloc,use_crs" successfully modifies the PCI bridge windows to allow an external ExpressCard <> ViDock4 + Nvidia Quadro NVS420 with its 2 GPUs to be configured.
>
> With v3.16rc6 and rc7 it fails to do this, leaving the NVS420 inoperable.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

This continues to affect 3.16.
