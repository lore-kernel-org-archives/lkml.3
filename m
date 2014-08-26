Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaHZVx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:53:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34684 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbaHZVx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:53:58 -0400
Message-ID: <53FD01D0.8020203@zytor.com>
Date: Tue, 26 Aug 2014 14:53:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Ingo Molnar <mingo@redhat.com>
CC: =?UTF-8?B?TWFudGFzIE1pa3VsxJduYXM=?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 02:45 PM, Yinghai Lu wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
> 
> There are buggy EFI implementations: with EFI run time, kernel need
> to load file with 512bytes alignment when buffer is above 4G.
> 

This makes absolutely zero sense.  Please explain what the actual
problem is here.

	-hpa

