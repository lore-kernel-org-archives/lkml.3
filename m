Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab3IWWD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:03:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42514 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab3IWWDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:03:23 -0400
Message-ID: <5240BAA6.9090509@wwwdotorg.org>
Date: Mon, 23 Sep 2013 16:03:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: balbi@ti.com
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 1/3] usb: dwc3: msm: Add device tree binding information
References: <1377091786-5613-1-git-send-email-iivanov@mm-sol.com> <1377091786-5613-2-git-send-email-iivanov@mm-sol.com> <20130923193224.GO30811@radagast>
In-Reply-To: <20130923193224.GO30811@radagast>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 01:32 PM, Felipe Balbi wrote:
> Hi,
> 
> On Wed, Aug 21, 2013 at 04:29:44PM +0300, Ivan T. Ivanov wrote:
>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>> 
>> MSM USB3.0 core wrapper consist of USB3.0 IP from Synopsys (SNPS)
>> and HS, SS PHY's control and configuration registers.
>> 
>> It could operate in device mode (SS, HS, FS) and host mode (SS,
>> HS, FS, LS).
>> 
>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> and here's a new version from same patch

The binding looks pretty simple, so I don't think it's too contentious.

>> diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt
>> b/Documentation/devicetree/bindings/usb/msm-ssusb.txt

>> +MSM DWC3 controller wrapper

>> +Optional properties : +- gdsc-supply : phandle to the globally
>> distributed switch controller +  regulator node to the USB
>> controller.

If that's a regulator node, why not use xxx-supply properties to
interface with it?

Aside from that, the binding,
Acked-by: Stephen Warren <swarren@nvidia.com>
