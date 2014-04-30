Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422760AbaD3Qer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:34:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51663 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422657AbaD3Qep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:34:45 -0400
Message-ID: <536125F3.9050807@zytor.com>
Date: Wed, 30 Apr 2014 09:33:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com> <20140430103822.GD23736@pd.tnic>
In-Reply-To: <20140430103822.GD23736@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 03:38 AM, Borislav Petkov wrote:
> 
> Yah, this is how big a licensing boilerplate should be! Maybe other
> companies would look at this here and learn.
> 

Heh.  I think I might have used the wrong one, though... GPLv2+ vs GPLv2.

	-hpa

