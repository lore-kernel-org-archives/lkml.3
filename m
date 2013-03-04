Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab3CDWXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:23:15 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:42984 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3CDWXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:23:14 -0500
Message-ID: <51351CDF.6070003@pobox.com>
Date: Mon, 04 Mar 2013 17:14:55 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] [libata] Avoid specialized TLA's in ZPODD's Kconfig
References: <1663657.ypAtqGpGAq@vostro.rjw.lan> <1781256.mPQbtiUPYR@vostro.rjw.lan> <CA+55aFyzjN_wMH+2RCEA+aNLY0Z7fn4YU7VOtTALbgngn1+vCw@mail.gmail.com> <2223198.XmyRLgb3Gv@vostro.rjw.lan> <20130226161049.GA9303@kahuna> <CA+55aFy24fp+9zXiDmAgvsz6YvWQh2L0BAJ2hAhF7cNSdyMd8w@mail.gmail.com> <CA+55aFyu5woJsH2y3y=w4UFneOG8hKz_cLXgZQbJzn5asn8=hQ@mail.gmail.com> <20130226163712.GA30433@htj.dyndns.org> <CA+55aFyFRbMX9G_0Mv0nUZgw9mHAPzE0zCw5mCSbGG_r1diFHg@mail.gmail.com> <20130226165813.GB30433@htj.dyndns.org> <512CF809.8010102@pobox.com> <5130052E.9070403@intel.com> <5130A8DF.7080709@cogentembedded.com> <51318775.1060309@intel.com>
In-Reply-To: <51318775.1060309@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2013 12:00 AM, Aaron Lu wrote:
> ODD is not a common TLA for non-ATA people so they will get confused
> by its meaning when they are configuring the kernel. This patch fixed
> this problem by using ODD only after stating what it is.
>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
> v2:
> Add a space before open paren as suggested by Sergei Shtylyov.
>
>   drivers/ata/Kconfig | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)

applied



