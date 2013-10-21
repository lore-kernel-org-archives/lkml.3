Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3JUXum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 19:50:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:52151 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab3JUXuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 19:50:40 -0400
MIME-Version: 1.0
Message-ID: <trinity-77042b98-668c-487b-a742-63606ea159f2-1382399439150@3capp-gmx-bs07>
From: "Peter Huewe" <PeterHuewe@gmx.de>
To: "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>
Cc: "Ashley Lai" <adlai@linux.vnet.ibm.com>,
        "Ashley Lai" <ashley@ashleylai.com>,
        "Leonidas Da Silva Barbosa" <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, "Rajiv Andrade" <mail@srajiv.net>,
        tpmdd-devel@lists.sourceforge.net, "Sirrix AG" <tpmdd@sirrix.com>
Subject: Aw: Re: [tpmdd-devel] TPM patches for 3.12
Content-Type: text/plain; charset=UTF-8
Date: Tue, 22 Oct 2013 01:50:39 +0200 (CEST)
Importance: normal
Sensitivity: Normal
In-Reply-To: <20131020170017.GA32542@obsidianresearch.com>
References: <20131006193120.GA26137@obsidianresearch.com>
 <20131017145724.GA6528@obsidianresearch.com>
 <1382260018.11008.5.camel@fishsauce>,
 <20131020170017.GA32542@obsidianresearch.com>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:/na/Ma/TKR/kvYbzIMcCb6XFWSLDt36lRva8tlXdn5y
 HAlY9Rb+10Ww0ndTmCKeZmNIVUYVQo0UWn/Ee8QtJPuF1Cmml9
 F5aYCuzk9ckh8p32LVDfxrKKIdQZjCupt7xwJfqlJTGK2fSCnp
 AwPIpzhgY6J1RXuDRkzem0PTehRu+CKR2cJDwl/5kWnRWPZkKa
 cbU2smYfIRxGHtyE3Ez8yOLWM6bWFFqE0rZpoIIRpbPfSxkHmb
 CcnbHanuhvU47aMA/g05eJmlsbXw7xReZEpDI3AwmGTy4r/wQY Ms+jOk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, Ashley,

I just pushed the changes to my github tree 
https://github.com/PeterHuewe/linux-tpmdd/commits/for-james 
along with some additional changes:

- before the rename I made tpm.c checkpatch clean ;)

- I did some cleanup on the indention / white spaces of both Kconfig and bindings for both new drivers
- corrected the module name for the nuvoton i2c module

I detected similar problems with other entries in the kconfig so I
- did also correct the module name for the infineon i2c module (d'oh, my fault ;)
- and also corrected it for the stm i2c module
- cleaned the indention on the st i2c module

I'm currently compile testing it again, I definitely need a newer/faster (small/portable) laptop 
(donations welcome ;) - e.g. a 11" ultrabook ;)

Jason, can you please review and test my changes - 
I'd probably send the pull request out tomorrow then.
(giving me also the chance to think again whether I should add myself to MAINTAINERS or not ;)

Thanks,
Peter
