Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBSMOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:14:45 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49862 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaBSMOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:14:43 -0500
Date: Wed, 19 Feb 2014 12:14:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alexandre.torgue@st.com,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
Message-ID: <20140219121436.GE10504@lee--X1>
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org>
 <1392641818-23419-3-git-send-email-lee.jones@linaro.org>
 <20140218233645.GP31892@mtj.dyndns.org>
 <53049B7A.6080404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53049B7A.6080404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Cc: Tejun Heo <tj@kernel.org>
> >> Cc: linux-ide@vger.kernel.org
> >> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Please consider basing it on top of Hans' refactored ahci_platform.
> > 
> >  http://www.spinics.net/lists/linux-ide/msg47628.html
> 
> Which reminds I must test the version I've rebased on top of 3.14-rc1
> and then send a v6 so that this can get merged.
> 
> Lee, I'll add you to the CC of the v6 I'm about to send.

Thanks Hans.

Once Tejun has accepted this driver I will go ahead and rebase on top
of your work and convert to the new API.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
