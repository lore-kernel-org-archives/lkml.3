Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbbAHIeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:34:24 -0500
Received: from smtprelay01.ispgateway.de ([80.67.18.43]:38337 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbbAHIeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:34:23 -0500
Message-ID: <54AE410B.40101@ladisch.de>
Date: Thu, 08 Jan 2015 09:34:19 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Raimonds Cicans <ray@apollo.lv>, linux-kernel@vger.kernel.org
Subject: Re: Questions about IOMMU & PCIe switch
References: <54ACB0D4.3000008@apollo.lv> <54AD21E2.2020100@ladisch.de> <54AD3D0B.6060501@apollo.lv>
In-Reply-To: <54AD3D0B.6060501@apollo.lv>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raimonds Cicans wrote:
> https://github.com/ljalves/linux_media/issues/66

If the TBS driver works, why don't you use it?

The WARNING from the kernel log indicates a hardware bug in the PCIe
bridge.  Do you have the same card, and do you also get this warning
with kernel 3.16?

I/O virtualization requires handling packets from different devices
differently.  Problems with DMAR might indicate that some PCIe device
does not correctly identify itself as the source of PCIe packets.


Regards,
Clemens
