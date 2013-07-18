Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362Ab3GRRTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:19:21 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:60015 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3GRRTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:19:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307171435000.8258@kaball.uk.xensource.com>
References: <1373898219-15713-1-git-send-email-julien.grall@linaro.org> <alpine.DEB.2.02.1307171435000.8258@kaball.uk.xensource.com>
From: Julien Grall <julien.grall@linaro.org>
Date: Thu, 18 Jul 2013 18:18:48 +0100
Message-ID: <CAPnVf8z1YQsRsznag-Z+mnMTu9JxgWptYcDfoswzE-x0aJCDwg@mail.gmail.com>
Subject: Re: [PATCH] xen/arm: enable PV control for ARM
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: konrad.wilk@oracle.com, Ian Campbell <ian.campbell@citrix.com>,
        Patch Tracking <patches@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 July 2013 14:40, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 15 Jul 2013, Julien Grall wrote:
>> Enable power management from the toolstack for ARM guest.
>>
>> Signed-off-by: Julien Grall <julien.grall@linaro.org>
>
> Considering that now we support both ARM and ARM64, could you please
> add an ifneq ($(CONFIG_ARM64),y) too around cpu_hotplug.o, since you are
> at it?

Yes. I will resend the patch.

-- 
Julien Grall
