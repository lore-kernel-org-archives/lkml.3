Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab3KLX2w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 18:28:52 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56723 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab3KLX2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 18:28:46 -0500
Message-ID: <5282B9AC.8050200@lwfinger.net>
Date: Tue, 12 Nov 2013 17:28:44 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Demers <alexandre.f.demers@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence r8712u info and add verbose option v2
References: <1384281793-4733-1-git-send-email-alexandre.f.demers@gmail.com>	<52827E16.1030001@lwfinger.net>	<20131112210641.GB23241@kroah.com> <CAPEhTTFRW02A+4cgOB_gQ=Q_VJ9z-NjF_Jyw1rogiqebg5hA=Q@mail.gmail.com>
In-Reply-To: <CAPEhTTFRW02A+4cgOB_gQ=Q_VJ9z-NjF_Jyw1rogiqebg5hA=Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2013 04:38 PM, Alexandre Demers wrote:
> Hi Larry and Greg,
> You are right about the v2 thing and the Signed-off-by. It's the first
> time I submit a patch directly to the kernel list, I didn't go to the
> bottom of the SubmittingPatches, I should have read the whole document
> and not stop in the middle of it. I'll finish reading it and do what
> is expected. Greg, I understand your comment: I would have had the
> answer if I had read the whole document (it's in there, I've just seen
> it).
>
> However, I'll take the opportunity you are offering me, Larry, with
> your last question: I was asking myself the same question about simply
> deleting the statement which seems pretty useless to me. On the other
> hand, should we continue writing patches against r8712u? I'm not aware
> of the conclusion about replacing r8712u by r92su. Was there any
> decision taken on the subject?

I am not involved in the r92su project. My impression is that the latest 
proponent of that change was not happy with the information that r92su would 
still be in staging, but without mac80211 there is no other choice.

If there are parts of r8712u that are problems for you, then patch them. I will 
review them, but I am not likely to contribute other than for things that are bugs.

Larry


