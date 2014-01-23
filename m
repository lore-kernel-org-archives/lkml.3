Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755765AbaAWTl1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:41:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29699 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbaAWTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:41:25 -0500
Message-ID: <52E17087.2060301@oracle.com>
Date: Thu, 23 Jan 2014 14:41:59 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
References: <52DE94A9.9060505@oracle.com> <20140121161438.GD9004@pd.tnic> <52DEB4A9.4070707@oracle.com> <20140121182554.GE9004@pd.tnic> <52E15AAE.4090106@oracle.com> <20140123192939.GB11190@pd.tnic>
In-Reply-To: <20140123192939.GB11190@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 02:29 PM, Borislav Petkov wrote:
> On Thu, Jan 23, 2014 at 01:08:46PM -0500, Boris Ostrovsky wrote:
>> So I tried this on a "good" system and I am pretty sure this is
>> broken. I don't have any microcode in initrd and I am still dying in
>> load_microcode_amd().
> 32-bit still or 64-bit?

32-bit only.

-boris


