Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3EaUW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32902 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3EaUWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:22:19 -0400
Message-ID: <51A90666.2070508@zytor.com>
Date: Fri, 31 May 2013 13:21:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] x86: Fix adjust_range_size_mask calling position
References: <1370015587-20835-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1370015587-20835-1-git-send-email-yinghai@kernel.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 08:53 AM, Yinghai Lu wrote:
> 
> We need this one for v3.9 stable.
> 

The right way to express this is:

Cc: <stable@vger.kernel.org> v3.9

	-hpa


