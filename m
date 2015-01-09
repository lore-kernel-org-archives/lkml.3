Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbbAIPlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:41:51 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:60075 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbbAIPlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:41:50 -0500
Message-ID: <54AFF6BC.20007@cogentembedded.com>
Date: Fri, 09 Jan 2015 18:41:48 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Chunhao Lin <hau@realtek.com>, netdev@vger.kernel.org
CC: nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/8] r8169:change rtl8168dp jumbo frame patch
References: <1420817166-9868-1-git-send-email-hau@realtek.com> <1420817166-9868-2-git-send-email-hau@realtek.com>
In-Reply-To: <1420817166-9868-2-git-send-email-hau@realtek.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/9/2015 6:25 PM, Chunhao Lin wrote:

> RTL8168DP jumbo frame patch is the same as RTL8168C. So, for RTL8168DP,
> change to use RTL8168C jumbo frame patch. Also reomve uncessary function

    s/reomve uncessary/remove unnecessary/.

> "r8168dp_hw_jumbo_enable" and "r8168dp_hw_jumbo_disable".
>
> Signed-off-by: Chunhao Lin <hau@realtek.com>

WBR, Sergei

