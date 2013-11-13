Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759570Ab3KMRRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:17:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49409 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3KMRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:16:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v11] dmaengine: Add MOXA ART DMA engine driver
Date: Wed, 13 Nov 2013 18:16:12 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, djbw@fb.com, linux@arm.linux.org.uk,
        mark.rutland@arm.com
References: <1381155034-11254-1-git-send-email-jonas.jensen@gmail.com> <1381221756-4925-1-git-send-email-jonas.jensen@gmail.com> <20131113135912.GA8834@intel.com>
In-Reply-To: <20131113135912.GA8834@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311131816.13268.arnd@arndb.de>
X-Provags-ID: V02:K0:ZCfgBAlgd03R6YJ2oHsoYTy/a1vodV2cu5ltrIYi0Mk
 ULIuy8fkz/KcP0TPuNAlhiDA/ufTUzjsVOp+/4CdPP8jMSjWy5
 wLCZdNgOYnBn2LrMb/9YkwiPeTbZ8ckaKB90msZhaA1xCB9ZGm
 +Pg9uHIQ4SLeJ5pK+tYVbWwtjTrFfSuDLqusuMDbL5PvKXoV/E
 LlKqs1kdbSchdr77zABxzN0ic0OuRi6S5sVdeCLBfUmN+kOEZW
 lXXKvSr6HKqlMXkh+FwbZUKR+YA0sfnR6s2u8t71u4HcH9AGzu
 hcxKvQOAJr/yQLx8saLJ3laWr0LuC6ievoSzPbrFbFOVnNQtwL
 k1e/kFriuqId5RL8mbD8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 November 2013, Vinod Koul wrote:
> On Tue, Oct 08, 2013 at 10:42:36AM +0200, Jonas Jensen wrote:
> > The MOXA ART SoC has a DMA controller capable of offloading expensive
> > memory operations, such as large copies. This patch adds support for
> > the controller including four channels. Two of these are used to
> > handle MMC copy on the UC-7112-LX hardware. The remaining two can be
> > used in a future audio driver or client application.
> I see this is pending and I first need the AKC on DT parts of the patch before
> we can apply this.
> 
> Also pls cc dmaengine@vger.kernel.org on this patch

The DT binding looks good to me

Acked-by: Arnd Bergmann <arnd@arndb.de>

However, in the future, such binding should also be sent to the
devicetree@vger.kernel.org list for review, in a separate patch,
as clarified during the kernel summit.

	Arnd
