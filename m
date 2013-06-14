Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3FNIpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:45:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:62572 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3FNIpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:45:31 -0400
MIME-Version: 1.0
In-Reply-To: <51BA1BBF.6050106@wwwdotorg.org>
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com>
 <1371114745-24710-3-git-send-email-acourbot@nvidia.com> <51BA1BBF.6050106@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Fri, 14 Jun 2013 17:45:10 +0900
Message-ID: <CAAVeFuL0fsFk=rODaE9C8k04CacvyNu3AMrqDgHBOitY93tEpw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ARM: tegra: split setting of CPU reset handler
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>, Joseph Lo <josephl@nvidia.com>,
        Karan Jhavar <kjhavar@nvidia.com>, Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 4:21 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
>> Not all Tegra devices need to set the CPU reset handler in the same way.
>
> s/need/can/ ?

Fixed, thanks!
Alex.
