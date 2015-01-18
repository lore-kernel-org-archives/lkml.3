Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbbARNts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 08:49:48 -0500
Received: from srv-hp10.netsons.net ([94.141.22.72]:33313 "EHLO
	srv-hp10.netsons.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751184AbbARNtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 08:49:45 -0500
Message-ID: <54BBB9F4.1010404@lucaceresoli.net>
Date: Sun, 18 Jan 2015 14:49:40 +0100
From: Luca Ceresoli <luca@lucaceresoli.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Srikrishan Malik <srikrishanmalik@gmail.com>,
        devel@driverdev.osuosl.org, Peng Tao <bergwolf@gmail.com>,
        linux-kernel@vger.kernel.org, HPDD-discuss@ml01.01.org,
        Jinshan Xiong <jinshan.xiong@intel.com>
Subject: Re: [PATCH 2/2] staging: lustre: declare internal symbols as static
References: <1421188383-14216-1-git-send-email-luca@lucaceresoli.net> <1421188383-14216-2-git-send-email-luca@lucaceresoli.net> <20150118000214.GA25744@kroah.com>
In-Reply-To: <20150118000214.GA25744@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv-hp10.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: srv-hp10.netsons.net: authenticated_id: luca+lucaceresoli.net/only user confirmed/virtual account not confirmed
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg,

Greg Kroah-Hartman wrote:
> On Tue, Jan 13, 2015 at 11:33:03PM +0100, Luca Ceresoli wrote:
>> Fixes dozens of sparse warnings like:
>>    warning: symbol 'cfs_tracefile_sem' was not declared. Should it be static?
>>
>> Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
>> Cc: Peng Tao <bergwolf@gmail.com>
>> Cc: Jinshan Xiong <jinshan.xiong@intel.com>
>> Cc: Srikrishan Malik <srikrishanmalik@gmail.com>
>> Cc: HPDD-discuss@lists.01.org
>> Cc: devel@driverdev.osuosl.org
>> Cc: linux-kernel@vger.kernel.org
>
> This patch fails to apply to my staging-next branch, sorry :(

Some of my fixes were done by somebody else in the meantime.

Several people are sending small fixes for staging every day.
So, to reduce the probability of further conflicts, I'm resending
this patch as a set of smaller ones.

-- 
Luca
