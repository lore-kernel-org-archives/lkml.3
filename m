Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760991Ab3BNNrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:47:53 -0500
Received: from ns.iliad.fr ([212.27.33.1]:46358 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757726Ab3BNNrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:47:51 -0500
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2013 08:47:50 EST
Message-ID: <511CE939.5000705@freebox.fr>
Date: Thu, 14 Feb 2013 14:40:09 +0100
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mircea Gherzan <mgherzan@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: net: bpf_jit: fix emit_swap16() for non ARMv6+.
References: <1360776125-14542-1-git-send-email-nschichan@freebox.fr> <1360776645-14726-1-git-send-email-nschichan@freebox.fr> <511C0662.8010309@gmail.com>
In-Reply-To: <511C0662.8010309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 10:32 PM, Mircea Gherzan wrote:
[...]
> Acked-by: Mircea Gherzan <mgherzan@gmail.com>

Hi,

Thanks Mircea. Russel, David, do you have any preference as to which path this 
patch should take (net tree or ARM tree) ?

Regards,

-- 
Nicolas Schichan
Freebox SAS
