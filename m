Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaJOQFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 12:05:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57311 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaJOQFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 12:05:40 -0400
Message-ID: <543E9B4B.9040608@zytor.com>
Date: Wed, 15 Oct 2014 09:05:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: Lockdep warning with init_espfix_ap()
References: <5436AB4A.1080900@redhat.com> <543E994F.5030406@zytor.com> <543E9ACE.7050009@redhat.com>
In-Reply-To: <543E9ACE.7050009@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2014 09:03 AM, Prarit Bhargava wrote:
>>
>> It is kind of a messy situation, because this code needs to allocate
>> memory but is run before the secondary CPU is fully up.  As such, it is
>> a false positive, at least in some ways.
> 
> Interesting -- FWIW, I can reproduce this 100% of the time on _one_ system.  It
> isn't a big deal and likely just worth noting at this point.  I *always* see it
> when bringing up CPU 64 (of 128).
> 

... because that is the first CPU which needs to allocate memory.

	-hpa


