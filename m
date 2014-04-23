Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbaDWQ4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:56:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41217 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447AbaDWQ4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:56:54 -0400
Message-ID: <5357F0A0.6040909@zytor.com>
Date: Wed, 23 Apr 2014 09:56:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andrew Lutomirski <amluto@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <535714A1.9080502@linux.intel.com> <CAObL_7HsnpGKRoBh+NZkW7SURqGx_4Dkfow=1-_7UU9uBV4UkA@mail.gmail.com> <53571A7D.8050702@zytor.com> <5357CD0B.5050003@oracle.com>
In-Reply-To: <5357CD0B.5050003@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 07:24 AM, Boris Ostrovsky wrote:
>>
>> Konrad - I really could use some help figuring out what needs to be done
>> for this not to break Xen.
> 
> This does break Xen PV:
> 

I know it does.  This is why I asked for help.

This is fundamentally the problem with PV and *especially* the way Xen
PV was integrated into Linux: it acts as a development brake for native
hardware.  Fortunately, Konrad has been quite responsive to that kind of
problems, which hasn't always been true of the Xen community in the past.

	-hpa

