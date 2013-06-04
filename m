Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3FDVUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:20:33 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57993 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3FDVUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:20:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v4] arm: zynq: Add cpuidle support
Date: Tue, 04 Jun 2013 23:29:28 +0200
Message-ID: <2279402.cTvpFSuaii@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51ADDE51.6040701@linaro.org>
References: <360abe7d7e8b8a0f785ec846c24fa5cb6658b956.1370330248.git.michal.simek@xilinx.com> <51ADDE51.6040701@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 04, 2013 02:32:17 PM Daniel Lezcano wrote:
> On 06/04/2013 09:17 AM, Michal Simek wrote:
> > Add support for cpuidle.
> > 
> > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > ---
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Queued up for 3.11, but I *wish* the changelog were a bit more elaborate ...

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
