Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbbAYLhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 06:37:50 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:41630 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbAYLhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 06:37:47 -0500
Message-ID: <54C4D589.3010406@cogentembedded.com>
Date: Sun, 25 Jan 2015 14:37:45 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>,
        "K. Y. Srinivasan" <kys@microsoft.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] hyperv: netvsc.c: fixup-of-wait_for_completion_timeout-return-type
References: <1422183808-7655-1-git-send-email-der.herr@hofr.at>
In-Reply-To: <1422183808-7655-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/25/2015 2:03 PM, Nicholas Mc Guire wrote:

    You probably want to replace hyphens with spaces in the subject of this 
and other patches.
    And you're not fixing the return type of wait_for_completion_timeout(), 
you're fixing the variables to match this type.

> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

WBR, Sergei

