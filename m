Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3E3SEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:04:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52792 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756274Ab3E3SEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:04:25 -0400
Message-ID: <51A794A4.1010502@wwwdotorg.org>
Date: Thu, 30 May 2013 12:04:20 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: "'thierry.reding@avionic-design.de'" 
	<thierry.reding@avionic-design.de>,
        "'linux@arm.linux.org.uk'" <linux@arm.linux.org.uk>,
        "'bhelgaas@google.com'" <bhelgaas@google.com>,
        "'olof@lixom.net'" <olof@lixom.net>,
        "'mturquette@linaro.org'" <mturquette@linaro.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-tegra@vger.kernel.org'" <linux-tegra@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-pci@vger.kernel.org'" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com> <1368010660-31465-4-git-send-email-jagarwal@nvidia.com> <518A8596.7070702@wwwdotorg.org> <C79B248886DD134989C8FF6B096A91AB91B4886B5D@BGMAIL01.nvidia.com> <C79B248886DD134989C8FF6B096A91AB91B4886B6C@BGMAIL01.nvidia.com> <C79B248886DD134989C8FF6B096A91AB91B616BE9B@BGMAIL01.nvidia.com> <51A62042.7070304@wwwdotorg.org> <C79B248886DD134989C8FF6B096A91AB91B616BEA6@BGMAIL01.nvidia.com>
In-Reply-To: <C79B248886DD134989C8FF6B096A91AB91B616BEA6@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 11:37 AM, Jay Agarwal wrote:
...
> I have taken care of all your comments, but Ethernet device is not working for me neither on cardhu nor harmony. 
> Could be related to my process or board, Currently debugging this.

Are you talking about a PCIe-based Ethernet device on Harmony, or the
one that's built into the board?

The on-board Ethernet device is USB, and should work fine already, and
irrespective of any PCIe patches.

I have only tried an XHCI USB controller in the PCIe slot on Harmony, so
I can't say if Ethernet not working is a regression or not. Does the
Ethernet device work with just Thierry's patches and not yours?

> Parallely, should I push my patches for review so that it is clear from other aspects?

Well, if the patches don't work, I suppose there's not much use posting
them since they'll just need changes before they can be usefully applied
anyway. IIRC, most of my comments last time were fairly minor, so there
isn't much need for a separate review of them, right?
