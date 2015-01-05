Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbbAELGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:06:47 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:29119 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbAELGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:06:45 -0500
X-IronPort-AV: E=Sophos;i="5.07,698,1413270000"; 
   d="scan'208";a="54003987"
Message-ID: <54AA7042.50207@broadcom.com>
Date: Mon, 5 Jan 2015 12:06:42 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Brett Rudley <brudley@broadcom.com>,
        "Hante Meuleman" <meuleman@broadcom.com>,
        Fabian Frederick <fabf@skynet.be>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
References: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>	<54A8DBF4.4050202@lwfinger.net>	<CAKXHbyN6LH_pFw1uoLXRzgJv-NcjbTLJvMZXfwYXDwuk9QDszA@mail.gmail.com> <871tn933jc.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871tn933jc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/15 11:49, Kalle Valo wrote:
> Rickard Strandqvist<rickard_strandqvist@spectrumdigital.se>  writes:
>
>> As I hope you can see I have made some changes regarding the
>> subject-line. Thought it was an advantage to be able to see which file
>> I actually removed something from. There seems to be a big focus on
>> getting right on subject-line right in recent weeks.
>>
>> I wonder why there is a script that takes a file name, and respond
>> with an appropriate subject line?

Is there a script for this? Anyway, I would say driver name is enough. 
Enough about the subject line ;-) I would like to give some general 
remarks as you seem to touch a lot of kernel code. First off, I think it 
is good to remove unused stuff. However, I would like some more 
explanation on your methodology apart from "partially found by using a 
static code analysis program". So a cover-letter explaining that would 
have been nice (maybe still is). Things like Kconfig option can affect 
whether function are used or not so how did you cover that.

Regards,
Arend

> I don't think you can really automate this as some drivers do this a bit
> differently. You always need to manually check the commit log.
>
>> But ok, I change my script accordingly. Should I submit the patch again?
>
> Yes, please resubmit.
>

