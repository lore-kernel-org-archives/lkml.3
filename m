Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3KOKGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 05:06:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51888 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3KOKGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 05:06:36 -0500
Message-ID: <5285F209.1070204@zytor.com>
Date: Fri, 15 Nov 2013 02:06:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Christian Ruppert <christian.ruppert@abilis.com>
CC: Pavel Roskin <proski@gnu.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Noam Camus <noamc@ezchip.com>
Subject: Re: [PATCH 2/2] x86: Add support for uncompressed kernel images
References: <20131114083247.GB9687@ab42.lan> <1384418296-10374-2-git-send-email-christian.ruppert@abilis.com> <52850C28.8010800@zytor.com> <20131115094931.GB31656@ab42.lan>
In-Reply-To: <20131115094931.GB31656@ab42.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 01:49 AM, Christian Ruppert wrote:
> 
> Actually, the x86 architecture already contains a basic implementation
> of memcpy in its self-decompressor. Correct me if I'm wrong but I guess
> memmove is not required since I don't expect the output of a generic
> decompression function to overlap with its input.
> 
> We can simply use that function if we agree that
> . either nozip is x86 specific
> . or every architecture using this code must bring along its own memcpy
>   implementation in its self-decompressor.
> 
> Do you think that would be OK?
> 

I think all of them have memcpy().

	-hpa


