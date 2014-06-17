Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbaFQQEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:04:30 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28559 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbaFQQE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:04:28 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-c4-53a0670a500a
Message-id: <53A066F8.9060702@samsung.com>
Date: Tue, 17 Jun 2014 18:04:08 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, chow.kim@samsung.com,
        vikas.sajjan@samsung.com
Subject: Re: [PATCH v4 09/11] ARM: EXYNOS: Move "mach/map.h" inclusion from
 regs-pmu.h to platsmp.c
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
 <1399704998-13321-10-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1399704998-13321-10-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t/xK7pc6QuCDSbNVLdYNukum0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vFzWfbmRw4PFqae9g8Ni+p9+jbsorR4/MmuQCW
	KC6blNSczLLUIn27BK6M7fNYCqaxVqz9c4e1gXE6SxcjJ4eEgInE3b27oGwxiQv31rN1MXJx
	CAksZZSY+O8DlPOZUeJE/0ywKl4BLYnD96cwgdgsAqoS59/eYQex2QTUJD43PGIDsfmBatY0
	XQeq5+AQFYiQeHxBCKJVUOLH5HssIDNFBKYwSlzsWcYIkmAWSJb4dO4HM4gtLJAqcfv/BqjF
	HYwSh/7tAEtwCnhJ/L2whgmiQUdif+s0NghbXmLzmrfMExgFZyFZMgtJ2SwkZQsYmVcxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihIT+lx2Mi49ZHWIU4GBU4uGNuDQ/WIg1say4MvcQowQH
	s5IIb4n4gmAh3pTEyqrUovz4otKc1OJDjEwcnFINjFGxF7f/figTVDPZS8fh/Xalqx0Rv06d
	3PXt5ha/lrIzK+ZMjtGZXsrUvMUy6evu25qaLE+1H59Qjw7zsLHaySf1IHxBzKEX344dW/XL
	SffyfH7dRk/5Hn5O+RNHtvnf86g96L51du+Sj7PVD959y783K+H2asuy5lMPO36aH2jh3mo7
	49S+uTeVWIozEg21mIuKEwF4ENVxWwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.05.2014 08:56, Pankaj Dubey wrote:
> As we have removed static mappings from "regs-pmu.h" it does not
> need map.h anymore. But "platsmp.c" needed this and till now it
> got included indirectly. So lets move header inclusion of
> "mach/map.h" from "regs-pmu.h" to "platsmp.c".
> 
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>  arch/arm/mach-exynos/platsmp.c  |    1 +
>  arch/arm/mach-exynos/regs-pmu.h |    2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)

This could be probably squashed with other one of previous patches, but
anyway:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
