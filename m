Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbbAEKuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:50:08 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbAEKuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:50:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Brett Rudley <brudley@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Fabian Frederick <fabf@skynet.be>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list@broadcom.com,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
References: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54A8DBF4.4050202@lwfinger.net>
	<CAKXHbyN6LH_pFw1uoLXRzgJv-NcjbTLJvMZXfwYXDwuk9QDszA@mail.gmail.com>
Date: Mon, 05 Jan 2015 12:49:59 +0200
In-Reply-To: <CAKXHbyN6LH_pFw1uoLXRzgJv-NcjbTLJvMZXfwYXDwuk9QDszA@mail.gmail.com>
	(Rickard Strandqvist's message of "Sun, 4 Jan 2015 13:43:59 +0100")
Message-ID: <871tn933jc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:

> As I hope you can see I have made some changes regarding the
> subject-line. Thought it was an advantage to be able to see which file
> I actually removed something from. There seems to be a big focus on
> getting right on subject-line right in recent weeks.
>
> I wonder why there is a script that takes a file name, and respond
> with an appropriate subject line?

I don't think you can really automate this as some drivers do this a bit
differently. You always need to manually check the commit log.

> But ok, I change my script accordingly. Should I submit the patch again?

Yes, please resubmit.

-- 
Kalle Valo
