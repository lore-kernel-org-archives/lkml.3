Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaA1VEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 16:04:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32227 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043AbaA1VEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 16:04:36 -0500
Message-ID: <52E81B90.8040604@oracle.com>
Date: Tue, 28 Jan 2014 16:05:20 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
References: <52DE94A9.9060505@oracle.com> <20140121161438.GD9004@pd.tnic> <52DEB4A9.4070707@oracle.com> <20140121182554.GE9004@pd.tnic> <52E15AAE.4090106@oracle.com> <20140123192939.GB11190@pd.tnic> <52E17087.2060301@oracle.com> <20140128162431.GH815@pd.tnic> <52E8168D.9060805@oracle.com> <20140128205246.GL815@pd.tnic>
In-Reply-To: <20140128205246.GL815@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 03:52 PM, Borislav Petkov wrote:
> On Tue, Jan 28, 2014 at 03:43:57PM -0500, Boris Ostrovsky wrote:
>> It fixes the case when there is no microcode in initrd but when
>> microcode is corrupted (as was the case when we were pointing to Intel
>> binary) we still die. Neither container nor ucode_cpio.data is NULL in
>> this case.
> How is that possible? Did you generate a path in the cpio by the name of
>
> "kernel/x86/microcode/AuthenticAMD.bin"
>
> but with Intel microcode in it?
>

Yes. This was a bug in our build environment. It is fixed now but I put this
bug back when I was testing your patch.

-boris
