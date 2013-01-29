Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3A2Mrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:47:51 -0500
Received: from vaxjo.synopsys.com ([198.182.60.75]:56202 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3A2Mrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:47:48 -0500
Message-ID: <5107C483.7090503@synopsys.com>
Date: Tue, 29 Jan 2013 18:15:55 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: ARC Port for linux-next (was Re: [PATCH v3 00/44] Meta Linux Kernel
 Port)
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com> <5102BB38.3050207@imgtec.com> <201301260025.10020.arnd@arndb.de> <51062460.9060902@synopsys.com>
In-Reply-To: <51062460.9060902@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.164]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday 28 January 2013 12:40 PM, Vineet Gupta wrote:
> Hi Arnd / Stephen,
> 
> On Saturday 26 January 2013 05:55 AM, Arnd Bergmann wrote:

>> I'd suggest that you both ask Stephen to add the trees to linux-next
>> now (I thought you had done that already, but I don't see them there
>> at the moment).
> 
> Stephen, can you please add the following branch (rebased off 3.8-rc5) to linux-next
> 
> git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git  arc-next
> 
> With next-20130125, there's a trivial conflict in init/Kconfig - fixable by
> accepting both the hunks.

Please let me know if I'm missing anything before ARC Port could be added to
linux-next.

Thx,
-Vineet

