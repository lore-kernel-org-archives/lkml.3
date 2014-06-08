Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaFHPp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 11:45:56 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41135 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbaFHPpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 11:45:54 -0400
Message-ID: <5394852E.1000601@lwfinger.net>
Date: Sun, 08 Jun 2014 10:45:50 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Wu <peter@lekensteyn.nl>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: wireless: rtlwifi: rtl8192de: hw.c: Cleaning up
 conjunction always evaluates to false
References: <1402151419-18296-1-git-send-email-rickard_strandqvist@spectrumdigital.se> <1436639.AmJiDmeQZF@al> <CAFo99gb2gzLjv_4b3O-e0B1R8P5BTGbPJLuYYAmoyww9hkmrvA@mail.gmail.com> <3239222.FyGtueg2aO@al>
In-Reply-To: <3239222.FyGtueg2aO@al>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2014 05:43 AM, Peter Wu wrote:
> On Sunday 08 June 2014 12:36:11 Rickard Strandqvist wrote:
>> Then we use MSR_MASK instead, new patch then. But I will wait a day?
>> Or what is long enough to be sure that nobody else have any
>> objections? How is this usually resolved?
>
> Well, Larry is the maintainer, so he will ultimately pick up patches.
> One or two days should give people some time to read and reply.

My role as maintainer is a little different than others. As I have a private 
broadband connection with only 1 Mbps upload, it is not practical for me to 
operate a git server. I used to have an account at kernel.org, but I lost it 
after the break-in there. As I have never met face-to-face with another Linux 
developer, I have had no chance to have my credentials signed, so that resource 
is unavailable. As a result, I ACK or NACK patches and they are picked up by 
John Linville for drivers in the regular wireless tree, and Greg Kroah-Hartman 
for the staging drivers.

> As for MSR_MASK, that macro does not exist yet, I was wondering whether
> it's OK to add a new macro? (Larry?)

Yes, that is OK.

>> Sure, I can send a patch for all the files instead. However, earlier
>> received complaints when I sent patches extending over more than one
>> file.

These do really need to be split a little. There must be at least one patch for 
the wireless tree, and a second for staging. In fact, I prefer the way they are 
with one for each driver.

Larry

