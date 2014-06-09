Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbaFISd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:33:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41205 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaFISdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:33:53 -0400
Message-ID: <5395FE0E.80105@wwwdotorg.org>
Date: Mon, 09 Jun 2014 12:33:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com> <5390A8F9.2090408@wwwdotorg.org> <53915F3B.6050806@nvidia.com>
In-Reply-To: <53915F3B.6050806@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 12:27 AM, Mikko Perttunen wrote:
> The only compile-time dependencies here should be that:
> - patch 8 of 9 which contains the actual driver depends on patch 6 of 9
> (though only when building as a module) and the efuse series

> - patch 2 of 9 refers to the DT node called "padctl", so it requires the
> xusb series. (in the submitted xusb series, the node isn't actually
> named, though. I will fix this in v2)

Isn't that dependency a run-time dependency?

