Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbaDVINm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:13:42 -0400
Received: from gloria.sntech.de ([95.129.55.99]:38855 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaDVINe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:13:34 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Russ Dill <Russ.Dill@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, mans@mansr.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kbuild@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Dave Martin <Dave.Martin@arm.com>
Subject: Re: [RFC PATCH 00/11] Embeddable Position Independent Executable
Date: Tue, 22 Apr 2014 10:15:09 +0200
Message-ID: <1441820.DP5PYDOd2T@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <201310241009.12597.heiko@sntech.de>
References: <1379421817-15759-1-git-send-email-Russ.Dill@ti.com> <201310241009.12597.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russ,

Am Donnerstag, 24. Oktober 2013, 10:09:12 schrieb Heiko Stübner:
> Am Dienstag, 17. September 2013, 14:43:26 schrieb Russ Dill:
> > This patch adds support for and demonstrates the usage of an embedded
> > position independent executable (PIE). The goal is to allow the use of C
> > code in situations where carefully written position independent assembly
> > was previously required.
> 
> As suggested yesterday evening by Kevin Hilman, just adding my 2ct of
> support.
> 
> This series looks exactly like the foundation I'll need at some point in the
> (probably still distant) future to handle suspend on my Rockchip platform -
> where like in your example stuff like putting the ram into selfrefresh has
> to be done by the os.

just as it came up recently again for me and I couldn't find any newer version, 
ist this series still on the table?


Thanks
Heiko
