Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934788Ab3E2BYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:24:52 -0400
Received: from tundra.namei.org ([65.99.196.166]:60010 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932863Ab3E2BYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:24:50 -0400
Date: Wed, 29 May 2013 11:33:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: Tony Camuso <tcamuso@redhat.com>, linux-kernel@vger.kernel.org,
        LeonidasDaSilvaBarbosa <leosilva@linux.vnet.ibm.com>,
        AshleyLai <ashley@ashleylai.com>, sfr@canb.auug.org.au,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PULL] TPM: fix regression caused by section type conflict of
 tpm_dev_release() in ppc builds
In-Reply-To: <201305272218.41915.PeterHuewe@gmx.de>
Message-ID: <alpine.LRH.2.02.1305291132490.28040@tundra.namei.org>
References: <51A39A0C.8040405@redhat.com> <1369684307-11014-1-git-send-email-peterhuewe@gmx.de> <201305272218.41915.PeterHuewe@gmx.de>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 May 2013, Peter H?we wrote:

> Hi James,
> 
> The following changes since commit 5b88e270253db6d817e6a2f61909d1e53620e990:
> 
>  maintainers: Remove Kent from maintainers	
> 
> are available in the git repository at:
> 
>   git://github.com/PeterHuewe/linux-tpmdd.git for-james
> 
> for you to fetch changes up to e2fa3d799b7471f00adae59ff36260ad8237929f:
> 
>  tpm: fix regression caused by section type conflict of tpm_dev_release() in ppc builds

Pulled, thanks.


-- 
James Morris
<jmorris@namei.org>
