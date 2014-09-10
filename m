Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaIJRHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:07:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58709 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaIJRHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:07:47 -0400
Message-ID: <5410856E.7010207@wwwdotorg.org>
Date: Wed, 10 Sep 2014 11:07:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Marcel Ziswiler <marcel@ziswiler.com>
CC: alsa-devel@alsa-project.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        stefan@agner.ch
Subject: Re: [PATCH 2/3] ARM: tegra: apalis/colibri t30: integrate audio support
References: <cover.1410276224.git.marcel@ziswiler.com> <6194523f927bd7b4b50e1b4a8f3a2d0282cea502.1410276224.git.marcel@ziswiler.com>
In-Reply-To: <6194523f927bd7b4b50e1b4a8f3a2d0282cea502.1410276224.git.marcel@ziswiler.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 09:28 AM, Marcel Ziswiler wrote:
> Integrate Freescale SGTL5000 analogue audio codec support.

Patches 2 and 3 look OK. I'll hold off applying them until patch 1 is 
applied, just to make sure that the new DT binding there is accepted 
before I apply patches using it. If you could ping me when the patch is 
applied, that'd be very useful. Thanks.
