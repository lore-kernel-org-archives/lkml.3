Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaDKSUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:20:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46048 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754743AbaDKSUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:20:32 -0400
Message-ID: <53483260.2020308@zytor.com>
Date: Fri, 11 Apr 2014 11:20:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, stable@vger.kernel.org, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt:  Ban 16-bit segments on
 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <53483088.1010407@amacapital.net>
In-Reply-To: <53483088.1010407@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 11:12 AM, Andy Lutomirski wrote:
> 
> If this is what I think it is (hi, Spender), then it is probably only
> useful for 3.14.y and not earlier kernels.
> 

Not really.  The kernel stack address is sensitive regardless of kASLR;
in fact, it is completely orthogonal to kASLR.

	-hpa


