Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3ALAoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:44:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58513 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab3ALAoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:44:01 -0500
Message-ID: <50F0B1CE.7050300@wwwdotorg.org>
Date: Fri, 11 Jan 2013 17:43:58 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/2] usb: host: tegra: Resetting PORT0 based on
 information received via DT.
References: <1357198179-10031-1-git-send-email-vbyravarasu@nvidia.com> <1357198179-10031-3-git-send-email-vbyravarasu@nvidia.com> <50E5EA2C.609@wwwdotorg.org> <20130112001433.GB21909@kroah.com>
In-Reply-To: <20130112001433.GB21909@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 05:14 PM, Greg KH wrote:
> On Thu, Jan 03, 2013 at 01:29:32PM -0700, Stephen Warren wrote:
>> On 01/03/2013 12:29 AM, Venu Byravarasu wrote:
>>> Tegra USB host driver is using port instance number,
>>> to handle some of the hardware issues on SOC e.g. reset PORT0
>>> twice etc. As instance number based handling looks ugly,
>>> making use of information passed through DT for achieving this.
>>>
>>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>>> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>>
>> Greg, recall that I'm hoping to take this series through the Tegra tree
>> in order to manage EHCI/PHY/clock dependencies. I'm hoping to get your
>> ack if required, or is Alan's sufficient for this? Thanks.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks, applied to Tegra's for-3.9/usb branch.
