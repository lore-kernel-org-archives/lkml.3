Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3BAN4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:56:39 -0500
Received: from 8bytes.org ([85.214.48.195]:59439 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab3BAN4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:56:37 -0500
Date: Fri, 1 Feb 2013 14:56:33 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 0/4] Renesas IPMMU driver for sh7372, sh73a0 and
 r8a7740
Message-ID: <20130201135633.GH25591@8bytes.org>
References: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358765669-14567-1-git-send-email-hdk@igel.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Feb  1 14:56:36 2013
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510bc99422975734585213
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 07:54:25PM +0900, Hideki EIRAKU wrote:
> Hideki EIRAKU (4):
>   iommu/shmobile: Add iommu driver for Renesas IPMMU modules
>   ARM: mach-shmobile: sh7372: Add IPMMU device
>   ARM: mach-shmobile: sh73a0: Add IPMMU device
>   ARM: mach-shmobile: r8a7740: Add IPMMU device

Paul, Magnus, any opinions on patches 2-4? Can you ACK them when they
are ok for you?


	Joerg


