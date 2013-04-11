Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935175Ab3DKNeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:34:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55008 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933494Ab3DKNeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:34:17 -0400
Subject: Re: [PATCH] powerpc/crypto: removed qoriq-sec4.1-0.dtsi.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1365651819-23350-1-git-send-email-vakul@freescale.com>
Date: Thu, 11 Apr 2013 08:33:52 -0500
Cc: <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kim Phillips <kim.phillips@freescale.com>,
        Andy Fleming <afleming@freescale.com>,
        Shaveta Leekha <shaveta@freescale.com>, <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <DBED8846-60EE-41F8-B4C3-F24B3C1AB152@kernel.crashing.org>
References: <1365651819-23350-1-git-send-email-vakul@freescale.com>
To: Vakul Garg <vakul@freescale.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10, 2013, at 10:43 PM, Vakul Garg wrote:

> Removing qoriq-sec4.1-0.dtsi as it is not used by any soc anymore.
> 
> Signed-off-by: Vakul Garg <vakul@freescale.com>
> ---
> arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi |  109 -------------------------
> 1 files changed, 0 insertions(+), 109 deletions(-)
> delete mode 100644 arch/powerpc/boot/dts/fsl/qoriq-sec4.1-0.dtsi

applied to next

- k