Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab3E1XhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 19:37:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55753 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759267Ab3E1XhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 19:37:03 -0400
Message-ID: <51A53F84.2020208@zytor.com>
Date: Tue, 28 May 2013 16:36:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix adjust_range_size_mask calling position
References: <1369783706-27327-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1369783706-27327-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 04:28 PM, Yinghai Lu wrote:
> 
> Actually there is bug about calling sequence for
> adjust_range_page_size_mask(). Merge first will make
> adjust to 1g for second partial 1g range fail.
> 

Sorry, I'm not sure I understand what the above paragraph is trying to say.

	-hpa


