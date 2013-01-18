Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3ARR2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:28:43 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35475 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3ARR2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:28:41 -0500
Message-ID: <50F98646.6040209@wwwdotorg.org>
Date: Fri, 18 Jan 2013 10:28:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Alan Stern <stern@rowland.harvard.edu>,
        Venu Byravarasu <vbyravarasu@nvidia.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 4/4] usb: Add APIs to access host registers from Tegra
 PHY
References: <Pine.LNX.4.44L0.1301181029350.1988-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1301181029350.1988-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 08:30 AM, Alan Stern wrote:
> On Fri, 18 Jan 2013, Venu Byravarasu wrote:
> 
>> As Tegra PHY driver needs to access one of the Host registers,
>> added few APIs.
>>
>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>> ---
>> delta from v2:
>> Renamed USB_PORTSC1 to TEGRA_USB_PORTSC1.
>> Removed tegra_ehci_set_wakeon_events() and its references.
>> Used standard defines for accessing PORTSC fields defined in ehci_def.h
>> Included OCC bit of PORTSC as part of TEGRA_PORTSC1_RWC_BITS.
>>
>> delta from v1:
>> Taken care of RWC bits, while accessing PORTSC register.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Felipe, you said on a previous version that you weren't sure if you
could ack this since it means the PHY driver is touching EHCI
registers... I don't think we really have much choice w.r.t. what the
driver is doing, since it's driven purely by HW design. Is this updated
patched at least OK for you not to NAK it, and hence I can apply it? Thanks.
