Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaGOPpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:45:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56015 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaGOPpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:45:03 -0400
Message-ID: <53C54C62.8070403@zytor.com>
Date: Tue, 15 Jul 2014 08:44:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>, Yinghai Lu <yinghai@kernel.org>
CC: Matt Fleming <matt.fleming@intel.com>, Ingo Molnar <mingo@redhat.com>,
        linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org> <20140618142819.GN24049@console-pimps.org> <20140709182651.GB15932@console-pimps.org> <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com> <20140711074029.GD5952@console-pimps.org> <20140715151025.GB32039@console-pimps.org>
In-Reply-To: <20140715151025.GB32039@console-pimps.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 08:10 AM, Matt Fleming wrote:
> 
> Going forward, I suspect any attempts to use the EFI File Protocol are
> going to result in this kind of breakage, and that the only thing that
> can be relied upon is the Disk I/O Protocol.
> 

Do we know what the Windows bootloader does?  I thought it did use the
EFI File Protocol?
	
	-hpa

