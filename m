Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3AYT3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 14:29:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46153 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab3AYT3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 14:29:47 -0500
Message-ID: <5102DD08.9080204@zytor.com>
Date: Fri, 25 Jan 2013 11:29:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: mingo@elte.hu, Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3, v2] x86: xor-block handling adjustments
References: <5093E40902000078000A6147@nat28.tlf.novell.com> <20130124171554.GC11772@gmail.com> <51017028.3020001@zytor.com> <51024E9602000078000B97A2@nat28.tlf.novell.com>
In-Reply-To: <51024E9602000078000B97A2@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 12:21 AM, Jan Beulich wrote:
>>
>> I don't see anything wrong, except that I can't *find* patch 3/3 either
>> in my inbox nor on LKML...
> 
> I can certainly resend the whole set, but our email system even
> got a delivery confirmation from yours on patch 3 (other than
> e.g. from Ingo's, and all of this identical to 0...2).
> 
> Or see https://patchwork.kernel.org/patch/1688991/, according
> to which you even responded to it (which is the concern Ingo was
> referring to).
> 

Ah yes, now I have the context.

And with that, I have to NAK the patch.  I did talk to the KVM people
and they confirmed that this is NOT something they want.  They do not
program VT-x to VMEXIT on CR0 changes.

So this is Xen-specific, and penalizing other hypervisors is wrong.

	-hpa


