Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab3JVRzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:55:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51783 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab3JVRzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:55:50 -0400
Message-ID: <5266BC18.1080308@linux.vnet.ibm.com>
Date: Tue, 22 Oct 2013 12:55:36 -0500
From: Joel Schopp <jschopp@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        adlai@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: MAINTAINERS: Add myself as tpm maintainer
References: <1382463410-2018-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1382463410-2018-1-git-send-email-peterhuewe@gmx.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102217-7182-0000-0000-000008D83CCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 12:36 PM, Peter Huewe wrote:
> Since I'm actively maintaining the tpm subsystem for a few months now,
> it's time to step up and be an official maintainer for the tpm subsystem,
> atleast until I hear something different from my company.
> 
> The maintaining is done solely in my private time, out of private interest.
> Speaking only on behalf of myself, trying to be as vendor neutral as possible.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4fde706..936adb4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8475,6 +8475,7 @@ F:	drivers/media/usb/tm6000/
>  TPM DEVICE DRIVER
>  M:	Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
>  M:	Ashley Lai <ashley@ashleylai.com>
> +M:	Peter Huewe <peterhuewe@gmx.de>
>  M:	Rajiv Andrade <mail@srajiv.net>
>  W:	http://tpmdd.sourceforge.net
>  M:	Marcel Selhorst <tpmdd@selhorst.net>
> 

I have no objection to you adding yourself here.  I do think we should
probably also cut the list down at the same time as I don't think all
the listed maintainers are active anymore.  Also, the list is getting a
bit unwieldy.  If everyone maintains it nobody maintains it.

