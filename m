Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025Ab3EQWGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:06:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46356 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923Ab3EQWG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 18:06:27 -0400
Message-ID: <5196A9DE.5080700@wwwdotorg.org>
Date: Fri, 17 May 2013 16:06:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, stern@rowland.harvard.edu, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4 3/8] ARM: tegra: update device trees for USB binding
 rework
References: <1368713582-29038-1-git-send-email-vbyravarasu@nvidia.com> <1368713582-29038-4-git-send-email-vbyravarasu@nvidia.com> <51956574.5070206@wwwdotorg.org>
In-Reply-To: <51956574.5070206@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2013 05:02 PM, Stephen Warren wrote:
> On 05/16/2013 08:12 AM, Venu Byravarasu wrote:
>> This patch updates all Tegra board files so that they contain all the
>> properties required by the updated USB DT binding. Note that this patch
>> only adds the new properties and does not yet remove the old properties,
>> in order to maintain bisectability. The old properties will be removed
>> once the driver has been updated to assume the new bindings.
> 
> This series looks almost OK now. The one remaining issue is that in this
> patch, the regulator-name properties don't match the schematics, and in
> the Whistler patch below, both regulators you added have the same
> regulator-name, which causes problems.
> 
> To fix this, when I apply this patch, I'm going to fold in the patch
> I'll paste below.
> 
> Right now, I can't get Whistler to see the SD card. This is true even
> without your patches. Once I've resolved that and tested Whistler,
> assuming no more problems, I'll apply patches 1-3 to the Tegra tree, and
> set up a branch that can be pulled into the USB tree so the rest of the
> series can be applied there.

I've made Whistler boot by reverting a few commits entirely unrelated to
USB or your patch series. I'll investigate those later, but for not your
patches test out fine on Whistler. So, I'll apply patches 1-3 in the
series and set up the pull request for the USB tree. Thanks.
