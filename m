Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbbAGMOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:14:46 -0500
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:42852 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbAGMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:14:43 -0500
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2015 07:14:43 EST
Message-ID: <54AD21E2.2020100@ladisch.de>
Date: Wed, 07 Jan 2015 13:09:06 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>, linux-kernel@vger.kernel.org
Subject: Re: Questions about IOMMU & PCIe switch
References: <54ACB0D4.3000008@apollo.lv>
In-Reply-To: <54ACB0D4.3000008@apollo.lv>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raimonds Cicans wrote:
> We have two kinds of PCIe cards:
> A1 - based on chip B
> A2 - based on same chip B but behind PCIe switch
>
> Card A1 work flawlessly in any configuration,
> but card A2 work flawlessly only if system
> lack IOMMU or have disabled IOMMU

In theory, such a switch should be transparent.

> Do we have to treat card with PCIe switch in special way?

No.  But the switch has to work correctly, and driver must be
written correctly.

Which switch?  Which driver?


Regards,
Clemens
