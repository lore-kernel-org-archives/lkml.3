Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3JXIJa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:09:30 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55533 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308Ab3JXIJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:09:28 -0400
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 00/11] Embeddable Position Independent Executable
Date: Thu, 24 Oct 2013 10:09:12 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Russ Dill <Russ.Dill@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, mans@mansr.com,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kbuild@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
In-Reply-To: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201310241009.12597.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 17. September 2013, 14:43:26 schrieb Russ Dill:
> This patch adds support for and demonstrates the usage of an embedded
> position independent executable (PIE). The goal is to allow the use of C
> code in situations where carefully written position independent assembly
> was previously required.

As suggested yesterday evening by Kevin Hilman, just adding my 2ct of support.

This series looks exactly like the foundation I'll need at some point in the 
(probably still distant) future to handle suspend on my Rockchip platform - 
where like in your example stuff like putting the ram into selfrefresh has to 
be done by the os.


Thanks for the work on this
Heiko
