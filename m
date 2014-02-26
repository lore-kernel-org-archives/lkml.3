Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaBZVw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:52:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.13]:50969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBZVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:52:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: DMABOUNCE in pci-rcar
Date: Wed, 26 Feb 2014 22:52:08 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>, Ben Dooks <ben-linux@fluff.org>,
        Simon Horman <horms+renesas@verge.net.au>
References: <201402241200.21944.arnd@arndb.de> <5165962.7bqj51B15Z@wuerfel> <CAErSpo5uHCOpMGxdbtBwvZEV0jNOBkBch0rG-VVwxdLJgCkUnA@mail.gmail.com>
In-Reply-To: <CAErSpo5uHCOpMGxdbtBwvZEV0jNOBkBch0rG-VVwxdLJgCkUnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201402262252.08817.arnd@arndb.de>
X-Provags-ID: V02:K0:DLJxkINRFQQ5quEQKLdDqHlSJBtg2Vb+QC+lYAzk7SY
 qN2xw+ghcybsY74d3cLB9ZvdUEPWHv6DEheQs5L5Ctl8ng1Z2s
 hlSG72C7MNpweQvyQZovElo7rl+/z6JQykhyXcF5tDXJatdiZC
 LpowrnLAWfbR1tOh4c9pglm3+oi0+CsYV7NbfSDP1tnDzo5ZKy
 sC9DfXyFx0aHGeebwCyF8x7ZYXZhGMDeDnkUERskW47QlPETjv
 0/gc8dB4fa0A8oB4+6Xv3zaE+xiUT4tTd/SwlDNrerRXsyhLWp
 ZLMIyi/uLlWlHgdegEyqBs4XZDAOCVBaGcHFKvNHmkA7RVXiIV
 gW8KtlqpppuQlJyF58EU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 February 2014, Bjorn Helgaas wrote:
> OK, I dropped the DMABOUNCE and BOUNCE patches and force-updated my
> "next" branch.

Thanks!

	Arnd
