Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaBMI25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 03:28:57 -0500
Received: from mout.gmx.net ([212.227.15.18]:65418 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbaBMI2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 03:28:55 -0500
From: Marc Dietrich <marvin24@gmx.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Stefan Agner <stefan@agner.ch>, thierry.reding@gmail.com,
        josephl@nvidia.com, dev@lynxeye.de, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: don't timeout if CPU is powergated
Date: Thu, 13 Feb 2014 09:28:52 +0100
Message-ID: <4050206.sG2EzXyfMN@fb07-iapwap2>
User-Agent: KMail/4.12.2 (Linux/3.14.0-rc2-12.gfc9498b-desktop; KDE/4.12.2; x86_64; ; )
In-Reply-To: <52FBC97D.8040809@wwwdotorg.org>
References: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch> <52FBC97D.8040809@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V03:K0:Ciu+3prTCUcwY6imNg9dlbZ7Al4EpL/wsja7pqqq9g7ulu1QrQE
 t7HgTVkhZoj0YcAFlXf0/sen6CxNBBiXyo6vtPPFlfL0fIPLtanzP1HdAsXaRRcMXfYrdzS
 Fj3y5X1Z5Ol7cegiUOV9TKfbbWSPsCftyyD31vCKl09eg4QOgtvNcu1r4iSaOzHEKg+R6dc
 us5qMg4XVO0BkX6C2o8zg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 12. Februar 2014, 12:20:29 schrieb Stephen Warren:
> On 02/10/2014 05:44 PM, Stefan Agner wrote:
> > When booting secondary CPU(s) which are not yet powergated, a wrong
> > check lead to a timeout after 100 jiffies. With this patch, we only
> > delay powergating if CPUs are still not powered yet.
> 
> I've applied this to Tegra's for-3.15/soc branch.

also for 3.14 and maybe lower versioned kernels? Since this seems to fix a bug 
where some core doesn't come up.

Marc

