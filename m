Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbaJXUJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:09:50 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36213 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaJXUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:09:48 -0400
Message-ID: <544AB20A.8090208@codeaurora.org>
Date: Fri, 24 Oct 2014 13:09:46 -0700
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gioh Kim <gioh.kim@lge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>
CC: devel@driverdev.osuosl.org, gunho.lee@lge.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 1/3] staging: ion: shrink page-pool by page unit
References: <1414133248-639-1-git-send-email-gioh.kim@lge.com> <1414133248-639-2-git-send-email-gioh.kim@lge.com>
In-Reply-To: <1414133248-639-2-git-send-email-gioh.kim@lge.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/23/2014 11:47 PM, Gioh Kim wrote:
> This patch shrink page-pool by page unit.
>

Can you explain a bit more about what this patch is
fixing? The description in the cover letter would
be helpful here.

Thanks,
Laura

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
