Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936414Ab3DKO5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:57:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:34453 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756084Ab3DKO5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:57:30 -0400
Subject: Re: [PATCHv2] powerpc/crypto: Add property for 'era' in SEC dts crypto node
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1365651923-24017-1-git-send-email-vakul@freescale.com>
Date: Thu, 11 Apr 2013 08:34:01 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <7217580C-7107-4A96-9D8C-382AB68A19B0@kernel.crashing.org>
References: <1365651923-24017-1-git-send-email-vakul@freescale.com>
To: Vakul Garg <vakul@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10, 2013, at 10:45 PM, Vakul Garg wrote:

> The crypto node now contains a new property 'fsl,sec-era'.
> This is required so that applications can retrieve era info without
> having to be able to read SEC's register space.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
> Changelog:
> 
> 	v2: Added era in p1023si-post.dtsi as per Kim's comments.
> 
> arch/powerpc/boot/dts/fsl/p1023si-post.dtsi   |    1 +
> arch/powerpc/boot/dts/fsl/pq3-sec4.4-0.dtsi   |    1 +
> arch/powerpc/boot/dts/fsl/qoriq-sec4.0-0.dtsi |    1 +
> arch/powerpc/boot/dts/fsl/qoriq-sec4.2-0.dtsi |    1 +
> arch/powerpc/boot/dts/fsl/qoriq-sec5.0-0.dtsi |    1 +
> arch/powerpc/boot/dts/fsl/qoriq-sec5.2-0.dtsi |    1 +
> arch/powerpc/boot/dts/fsl/qoriq-sec5.3-0.dtsi |    1 +
> 7 files changed, 7 insertions(+), 0 deletions(-)

applied to next

- k
