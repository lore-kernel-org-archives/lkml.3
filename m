Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3CRUSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:18:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:33168 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab3CRUSd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:18:33 -0400
Subject: Re: [PATCH 1/1] Add a new platform tree for ib8315. Also add the DTS and the defconfig for that board.
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1363614452-1109-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
Date: Mon, 18 Mar 2013 15:18:15 -0500
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <307780DE-9735-4329-B5D7-DF2E9451A217@kernel.crashing.org>
References: <1363614452-1109-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
To: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 18, 2013, at 8:47 AM, Sergey Gerasimov wrote:

> Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
> ---
> arch/powerpc/boot/dts/ib8315.dts           |  490 +++++++
> arch/powerpc/configs/83xx/ib8315_defconfig | 2121 ++++++++++++++++++++++++++++
> arch/powerpc/platforms/83xx/Kconfig        |    7 +
> arch/powerpc/platforms/83xx/Makefile       |    1 +
> arch/powerpc/platforms/83xx/tqm8315.c      |  137 ++
> 5 files changed, 2756 insertions(+)
> create mode 100644 arch/powerpc/boot/dts/ib8315.dts
> create mode 100644 arch/powerpc/configs/83xx/ib8315_defconfig
> create mode 100644 arch/powerpc/platforms/83xx/tqm8315.c

Is there some relationship of this board with the TQM8315?

- k