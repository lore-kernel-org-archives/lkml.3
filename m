Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaFATcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:32:31 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60023 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaFATc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:32:29 -0400
Message-ID: <538B7FCB.5090106@cogentembedded.com>
Date: Sun, 01 Jun 2014 23:32:27 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: phy.c: Cleaning up
 uninitialized variables
References: <1401626948-16183-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<538B5714.6060107@cogentembedded.com> <CAFo99gYJ_K9qEaHihtvaFT4Wv3ApUZMJmTK=nuqK+=sA2NaYsA@mail.gmail.com>
In-Reply-To: <CAFo99gYJ_K9qEaHihtvaFT4Wv3ApUZMJmTK=nuqK+=sA2NaYsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/01/2014 08:44 PM, Rickard Strandqvist wrote:

> Okay, sorry. But you agree with what it is doing in general then?

    Now that you asked, I do agree. But generally my reply doesn't mean that I 
went and studied the patch context and verified that the patch is indeed correct.

> In this case, I am sending a new patch...

    BTW, it's worth mentioning in the change log that you're moving the 
variable in question into the block.

> Best regards
> Rickard Strandqvist

WBR, Sergei

