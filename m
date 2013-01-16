Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3APRSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:18:38 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40723 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342Ab3APRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:18:36 -0500
Message-ID: <50F6E0E9.9000601@wwwdotorg.org>
Date: Wed, 16 Jan 2013 10:18:33 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: balbi@ti.com, Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: remove unused APIs from Tegra PHY.
References: <1358245170-22083-1-git-send-email-vbyravarasu@nvidia.com> <50F59A43.7050308@wwwdotorg.org> <20130116071235.GB610@arwen.pp.htv.fi>
In-Reply-To: <20130116071235.GB610@arwen.pp.htv.fi>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 12:12 AM, Felipe Balbi wrote:
> Hi,
> 
> On Tue, Jan 15, 2013 at 11:04:51AM -0700, Stephen Warren wrote:
>> On 01/15/2013 03:19 AM, Venu Byravarasu wrote:
>>> As tegra_usb_phy_clk_disable/enable() are not being used,
>>> removing them.
>> 
>> Greg, Felipe,
>> 
>> Again if I may, I'll take this through the Tegra tree. I think
>> the next set of patches that Venu posts should actually expose
>> the dependencies between his USB patches and the Tegra clock
>> framework rework, which are why I want to do this.
> 
> that should be ok:
> 
> Acked-by: Felipe Balbi <balbi@ti.com>

Thanks. I've applied this to Tegra's for-3.9/usb branch.

BTW Venu, you forgot to Cc the linux-tegra mailing list; that's
probably more useful than linux-kernel for Tegra-specific driver changes.
