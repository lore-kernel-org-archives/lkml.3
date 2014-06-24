Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaFXM0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:26:49 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51362 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751984AbaFXM0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:26:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19NAz38AwKaV6+Zz8pRh/u6n6EpUUoodlU=
X-DKIM: OpenDKIM Filter v2.0.1 titan D2E3A59866A
Date: Tue, 24 Jun 2014 08:26:39 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: suravee.suthikulpanit@amd.com
Cc: marc.zyngier@arm.com, Catalin.Marinas@arm.com, Will.Deacon@arm.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Introduce ARM GICv2m MSI(-X) support
Message-ID: <20140624122639.GL10202@titan.lakedaemon.net>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 07:32:58PM -0500, suravee.suthikulpanit@amd.com wrote:
> This patch set introduces support for MSI(-X) in GICv2m specification,
> which is implemented in some variation of GIC400.
> 
> This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
> (https://lkml.org/lkml/2014/3/14/320).

Is this a build, boot, or runtime dependency?

thx,

Jason.
