Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaIVE3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 00:29:23 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49303 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaIVE3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 00:29:22 -0400
Message-ID: <541FA582.5020900@vlnb.net>
Date: Sun, 21 Sep 2014 21:28:50 -0700
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "scst.niko@gmail.com" <scst.niko@gmail.com>
CC: scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [ANNOUNCE]: SCST 3.0 released
References: <scr50ftb8lekn4h1of5mqdd9.1411196360032@email.android.com>
In-Reply-To: <scr50ftb8lekn4h1of5mqdd9.1411196360032@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:EyRWRPWBLNQ5dDErGDWuV8W17x6mA16TFUgnvqaM/KC
 ZRdK9tqBZaJlIEqNd+JmmumN5O6GpQdd/BsE/rkOyjZzJW+9tA
 bzdpC1a/x0rZnfFDsq3TmKTYrlyQkLVHGh0xN+pQ+j1L/8kFXT
 f3i1inUVP95TDANlrZs3kl0H2gXJ7e6G8qgO7sz+w5b8sH+CG7
 9tCz2pqKb7zLXWJwGsehP03sXY7D4sS+v0+1HykPnHqG/ZKxHK
 IgeIv+O6h6c5n8OnPqlf6jfLWxdg95wggbCCqHMTwCfTBPTx+7
 kjns5Gga4mRyZE4bj5LggRP3+1UaRkfSeydJMSeRV9bCoYx5mL
 ZVExXMRghGDfMxRSTnHI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, because it's too new, but you can always get it from the git. Or you 
can use stable Emulex driver for 16Gb connectivity. It's not in the 
bundle only because of the Emulex policy.

Thanks,
Vlad

On 9/19/2014 23:59, scst.niko@gmail.com wrote:
> Does 16Gb qla2x00t included?
>
> 发自我的小米手机
>
> Vladislav Bolkhovitin <vst@vlnb.net>于 2014-9-20 下午2:39写道：
>
>     Hi All,
>
>     I'm glad to announce that SCST 3.0 has just been released. This
>     release includes SCST
>     core, target drivers iSCSI-SCST for iSCSI, including iSER support
>     (thanks to
>     Mellanox!), qla2x00t for QLogic Fibre Channel adapters, ib_srpt for
>     InfiniBand SRP,
>     fcst for FCoE and scst_local for local loopback-like access as well
>     as SCST management
>     utility scstadmin. Also separately you can download from Emulex
>     development portal
>     stable and fully functional target driver for the current generation
>     of Emulex Fibre
>     Channel adapters.
>
>     SCST is alternative SCSI target stack for Linux. SCST allows
>     creation of sophisticated
>     storage devices, which provide advanced functionality, like
>     replication, thin
>     provisioning, deduplication, high availability, automatic backup,
>     etc. Majority of
>     recently developed SAN appliances, especially higher end ones, are
>     SCST based. It might
>     well be that your favorite storage appliance running SCST in the
>     firmware.
>
>     More info about SCST and its modules you can find on:
>     http://scst.sourceforge.net
>
>     Thanks to all who made it happen!
>
>     Vlad
