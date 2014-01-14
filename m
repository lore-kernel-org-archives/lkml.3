Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaANONT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:13:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANONR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:13:17 -0500
Message-ID: <52D545F7.2020503@redhat.com>
Date: Tue, 14 Jan 2014 09:13:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: atomlin@redhat.com, linux-kernel@vger.kernel.org
CC: mingo@kernel.org, oleg@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 2/2] hung_task: Display every hung task warning
References: <1389633292-23588-1-git-send-email-atomlin@redhat.com> <1389633292-23588-3-git-send-email-atomlin@redhat.com>
In-Reply-To: <1389633292-23588-3-git-send-email-atomlin@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 12:14 PM, atomlin@redhat.com wrote:
> From: Aaron Tomlin <atomlin@redhat.com>
> 
> Enable hung_task_warnings to display every hung
> task warning when set to -1.
> 
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>

Aaron and I talked on IRC, and after some talking these patches
now make sense to me :)

The kernel apparently limits how many hung task warnings it
will display at a time, when a timeout occurs.  Aaron's patch
allows that limit to be set to "unlimited", which will cause
the kernel to display info about all hung tasks.

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
