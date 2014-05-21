Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaEUKyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:54:03 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17306 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaEUKyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:54:01 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 May 2014 03:47:58 -0700
Date: Wed, 21 May 2014 13:53:57 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: pull request for Tegra clock fixes for 3.16
Message-ID: <20140521105357.GB15168@tbergstrom-lnx.Nvidia.com>
References: <20140519134049.GA20109@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140519134049.GA20109@tbergstrom-lnx.Nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:40:49PM +0200, Peter De Schrijver wrote:
> Hi Mike,
> 
> A number of fixes which are needed by the upcoming XHCI and SATA drivers.
> 

Did you take this one already? If not, please ignore it. I will make a new one
which includes the HDA clocks...

Cheers,

Peter.
