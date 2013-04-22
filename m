Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab3DVHEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:04:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60311 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3DVHES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:04:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 0/5] of_platform_driver and OF_DEVICE removal
Date: Mon, 22 Apr 2013 09:03:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Raisch <raisch@de.ibm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>, linuxppc-dev@lists.ozlabs.org,
        linux-rdma@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
In-Reply-To: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220903.54788.arnd@arndb.de>
X-Provags-ID: V02:K0:+REZnCpi+ZTvvzkDSOlMGKnTRhIrUeMWiu11UHYrSNZ
 08m3d95YiPXBExadrVlR/yeBiPzc+zicxXG5LuhT0sGsNh/JLy
 63EPVYgms4lLqYR3PD7sr1gmYsqdrXIzJ1QZ1F/rrnR/BPudq6
 vbr1kOdNI3GX2a8QLnfQom4L5V7tzQcnM/JdpZV4iNTnlANPVi
 JB6SnzljMML6SGZC+VivpRRytEdw6j7FOROdSbz4PokOSmMf0/
 c9ry/5O1xsdYBsqQXOtOIY1/iF2/NnWDTMwc4imp7sxLcY+rjc
 53ItNJXGa4liWudE4kPUqxsiRNBB+e1ZUpkPyUKu8YQajLVp6z
 5PVlqANQppeZ1pKK3wo4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This series is a relatively straight-forward removal of the last remaining
> user of of_platform_driver (ibmebus) and removal of CONFIG_OF_DEVICE which
> is always enabled when CONFIG_OF is enabled.
> 
> Compile tested on powerpc and sparc.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
