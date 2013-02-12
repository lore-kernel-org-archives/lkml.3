Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761341Ab3BLQFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:05:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35790
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758579Ab3BLQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:05:10 -0500
Message-ID: <511A6868.5010605@infradead.org>
Date: Tue, 12 Feb 2013 08:06:00 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: linux-next: Tree for Feb 12 (drm_pci.c)
References: <20130212160953.b80a57fec99e4bd9afb4b601@canb.auug.org.au>
In-Reply-To: <20130212160953.b80a57fec99e4bd9afb4b601@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/13 21:09, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20130211:
> 


when CONFIG_PCI is not enabled (on x86_64):

  CC [M]  drivers/gpu/drm/drm_pci.o
drivers/gpu/drm/drm_pci.c: In function 'drm_pcie_get_speed_cap_mask':
drivers/gpu/drm/drm_pci.c:485:2: error: implicit declaration of function 'pcie_capability_read_dword' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[4]: *** [drivers/gpu/drm/drm_pci.o] Error 1



-- 
~Randy
