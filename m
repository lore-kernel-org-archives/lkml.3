Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3JAWgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:36:55 -0400
Received: from mout.gmx.net ([212.227.17.21]:51196 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3JAWgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:36:52 -0400
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: tpmdd-devel@lists.sourceforge.net
Subject: Re: [tpmdd-devel] [PATCH 07/13] tpm: Remove tpm_show_caps_1_2
Date: Wed, 2 Oct 2013 00:38:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.10.9; KDE/4.10.5; x86_64; ; )
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
References: <1379960083-8942-1-git-send-email-jgunthorpe@obsidianresearch.com> <201310020009.22952.PeterHuewe@gmx.de> <20131001222113.GA22778@obsidianresearch.com>
In-Reply-To: <20131001222113.GA22778@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310020038.32404.PeterHuewe@gmx.de>
X-Provags-ID: V03:K0:5bRLoti4zYsfheNsZtGYKzuX9bjMRxAZExP6n+KbOiD6lvXidwu
 nMJBvLvZBeAtHZNqS8AwnkN7HvxdaFbBBxBtLvXimHPAnGvRlPJi/2wjsC2sKwXzVI3w1dF
 hZhDTACqqlzgn0OA9vTzgQ8pDX7h2TFKkTM3byIZK1FRB96pgb96rouXUVvKZJA8Iuxg26k
 SpOo0aFBhGrrQEJngvYLA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Am Mittwoch, 2. Oktober 2013, 00:21:13 schrieb Jason Gunthorpe:
> On Wed, Oct 02, 2013 at 12:09:22AM +0200, Peter H?we wrote:
> >    Since the tpm_spi_stm_st33, tpm_i2c_nuvoton and tpm_i2c_atmel drivers
> >    are not yet merged and were heavily improved by you anyway, please
> >    include this improvement directly in the new drivers.
> 
> Okay, it is easy enough to invert the patch order and put the drivers
> last. I am not submitting the st33 driver, but when things are done I
> will send Mathias a patch with the changes from this series that are
> needed and he can deal with re-submitting his driver.
> 
> FWIW, I needed the drivers first to keep my world sane when testing
> this thing, so the patches are all as-tested from my perspective.

nevermind and don't worry - the way you submitted the patches is perfectly 
fine for me.
You can keep the patches seperate and in case of doubt I can simply squash 
them in the end.

Thanks,
Peter
