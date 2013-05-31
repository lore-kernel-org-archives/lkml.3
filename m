Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3EaUTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:19:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3EaUS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:18:58 -0400
Message-ID: <51A9058D.3010303@zytor.com>
Date: Fri, 31 May 2013 13:18:21 -0700
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
> Commit 8d57470d cause a kernel panic while setting mem=2G.

As Ingo pointed out, don't just refer to a commit by number; you need to
include the number as well as the subject line.  This is particularly
important if git ever switches away from SHA-1.

	-hpa


