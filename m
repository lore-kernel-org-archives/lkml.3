Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab3KAItR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:49:17 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:54927 "EHLO Ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab3KAItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:49:16 -0400
Message-ID: <52736B04.6020505@tlinx.org>
Date: Fri, 01 Nov 2013 01:49:08 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFE?: why no 'bind' info in /proc/mounts?
References: <5272FE79.30801@tlinx.org> <20131101151521.2fa0b434@notabene.brown>
In-Reply-To: <20131101151521.2fa0b434@notabene.brown>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ah... didn't know about the other format file... thanks!

On 10/31/2013 9:15 PM, NeilBrown wrote:
> Take a look in /proc/self/mountinfo.  It contains more useful stuff about the
> mount table which couldn't be put in /proc/mounts without breaking
> compatibility.
>
> NeilBrown
>   

