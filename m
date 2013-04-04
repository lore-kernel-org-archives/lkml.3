Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607Ab3DDOVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:21:08 -0400
Received: from void.printf.net ([89.145.121.20]:33122 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761434Ab3DDOVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:21:05 -0400
From: Chris Ball <cjb@laptop.org>
To: "Luca Porzio \(lporzio\)" <lporzio@micron.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>,
        "linux-mmc\@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "vgoyal\@redhat.com" <vgoyal@redhat.com>,
        "tj\@kernel.org" <tj@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v1] mmc: card: Adding support for sanitize in eMMC 4.5
References: <1361705927-10524-1-git-send-email-ygardi@codeaurora.org>
	<26E7A31274623843B0E8CF86148BFE32B02F5779@NTXAVZMBX04.azit.micron.com>
Date: Thu, 04 Apr 2013 10:20:54 -0400
In-Reply-To: <26E7A31274623843B0E8CF86148BFE32B02F5779@NTXAVZMBX04.azit.micron.com>
	(Luca Porzio's message of "Mon, 11 Mar 2013 18:36:55 +0000")
Message-ID: <877gkipebd.fsf@octavius.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yaniv, Maya,

On Mon, Mar 11 2013, Luca Porzio (lporzio) wrote:
> In case of Sanitize timeout, the eMMC might go in an unclear state.
> May I suggest to:
> - issue an HPI before leaving thus bring the eMMC back into safe status
> - report the 'sanitize not complete error' and let the user decide on 
>   Whether he wants to re-issue (i.e. continue) the sanitize or just let 
>   it go.

Can you respond to this review feedback from Luca, please?

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
