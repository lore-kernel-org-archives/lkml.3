Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3KGVLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:11:02 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45045 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3KGVK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:10:56 -0500
Message-ID: <527C0195.50008@zytor.com>
Date: Thu, 07 Nov 2013 13:09:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        tglx@linutronix.de, Ingo Molnar <mingo@kernel.org>,
        steve.capper@linaro.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 09:17 AM, Ard Biesheuvel wrote:
> This series implements automatic module loading based on optional CPU features,
> and tries to do so in a generic way. Currently, 32 feature bits are supported,
> and how they map to actual CPU features is entirely up to the architecture.

NAK.

We in the x86 world already left 32 bits way behind; we currently have
320 bit feature masks.

If you're aiming at doing this in a generic way, it needs to be able to
accommodate the current x86cpu feature stuff as a subset, which this
doesn't.

	-hpa

