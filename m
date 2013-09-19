Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3ISSZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:25:47 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59098 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab3ISSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:25:45 -0400
Message-ID: <523B41A6.5040404@wwwdotorg.org>
Date: Thu, 19 Sep 2013 12:25:42 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: rob.herring@calxeda.com, mark.rutland@arm.com, pawel.moll@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] ARM: tegra: add palmas pincontrol to Dalmore device
 tree
References: <1379509642-19227-1-git-send-email-ldewangan@nvidia.com> <1379509642-19227-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1379509642-19227-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 07:07 AM, Laxman Dewangan wrote:
> Add Palmas pincontrol to Dalmore device tree and make following
> configuration as default:
> - Disable DVFS1 and DVFS2.
> - Set GPIO6 to gpio mode.

> - Not sure that this will create the issue with other node having same
>   name as pinmux in top of the dts file.

This isn't an issue. Node names need to be unique within their parents,
not globally.
