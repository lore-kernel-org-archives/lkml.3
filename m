Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbaD2OjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:39:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33800 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbaD2OjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:39:19 -0400
Message-ID: <535FB969.5080503@zytor.com>
Date: Tue, 29 Apr 2014 07:38:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Matt Fleming <matt@console-pimps.org>
CC: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 00/10] arm64: UEFI support
References: <1398442154-19974-1-git-send-email-leif.lindholm@linaro.org> <20140429102817.GE17007@arm.com> <20140429114356.GK26088@console-pimps.org> <20140429134726.GH17007@arm.com>
In-Reply-To: <20140429134726.GH17007@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:47 AM, Catalin Marinas wrote:
> 
> Waiting for the tip/x86/efi to be merged first is not a problem. We
> also need a stable base for testing the arm64 UEFI series, so I assume
> this series can be based onto tip/x86/efi (would such branch be rebased
> before hitting mainline?).
> 
> Given that Leif's series contains both generic efi and arm64 patches,
> what's your preference for merging them? I'm happy to add my ack and
> they go via your tree (or the other way around).
> 

tip:x86/efi will not be rebased (barring major unforseen events).

I'm not opposed to pushing the arm64 patches through -tip (via Matt), if
it works with your workflow, either.  Perhaps we need to rename the
branch to tip:core/efi...

	-hpa

