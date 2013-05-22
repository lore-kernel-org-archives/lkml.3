Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab3EVTDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:03:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087Ab3EVTDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:03:16 -0400
Message-ID: <519D1668.6000601@zytor.com>
Date: Wed, 22 May 2013 12:03:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: microcode loading got really slow.
References: <20130521230332.GC12713@redhat.com>
In-Reply-To: <20130521230332.GC12713@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 04:03 PM, Dave Jones wrote:
> In 3.10-rc2 I see this happening..
> 
> [   72.318133] microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x6
> [  132.446449] microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x6
> [  192.573101] microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x6
> [  252.702055] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> 
> For some reason the events for udev seem to be getting delayed 60s for each core.
> 
> 	Dave
> 

Is this a regression from -rc1?

	-hpa

