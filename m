Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaFQE4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:56:23 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51346 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbaFQE4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:56:22 -0400
Message-ID: <539FCA71.2000702@gmail.com>
Date: Tue, 17 Jun 2014 10:26:17 +0530
From: Anil Shashikumar Belur <askb23@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Drokin, Oleg" <oleg.drokin@intel.com>
CC: "Dilger, Andreas" <andreas.dilger@intel.com>,
        "<tao.peng@emc.com>" <tao.peng@emc.com>,
        "<gregkh@linuxfoundation.org>" <gregkh@linuxfoundation.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<hpdd-discuss@lists.01.org>" <hpdd-discuss@ml01.01.org>
Subject: Re: [PATCH v5 7/8] staging: lustre: lclient: lcommon_cl.c fixing
 coding style issues
References: <1402935742-18788-1-git-send-email-askb23@gmail.com> <1402935742-18788-8-git-send-email-askb23@gmail.com> <6FD758BB-2803-41BC-BFBF-2A607A68EAFA@intel.com>
In-Reply-To: <6FD758BB-2803-41BC-BFBF-2A607A68EAFA@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 17 June 2014 07:38 AM, Drokin, Oleg wrote:
> On Jun 16, 2014, at 12:22 PM, Anil Belur wrote:
>
>> From: Anil Belur <askb23@gmail.com>
>>
>> fixed: WARNING: line over 80 characters, used a new variable 'size_index' to
>> store the offset. Replace "unsigned long" with  "u64" type for
> Apparently you forgot to update the comment.
Thanks Oleg - overlooked it, will fix this shortly.
