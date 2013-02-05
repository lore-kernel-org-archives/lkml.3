Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3BEKVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:21:46 -0500
Received: from na3sys010aog106.obsmtp.com ([74.125.245.80]:48474 "HELO
	na3sys010aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751437Ab3BEKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:21:45 -0500
Message-ID: <5110DD31.3010801@ravellosystems.com>
Date: Tue, 05 Feb 2013 12:21:37 +0200
From: Izik Eidus <izik.eidus@ravellosystems.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Leonid Shatz <leonid.shatz@ravellosystems.com>,
        linux-kernel@vger.kernel.org,
        "'Andrea Arcangeli'" <aarcange@redhat.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>
Subject: Re: hrtimer possible issue
References: <510E58C2.9010207@ravellosystems.com> <alpine.LFD.2.02.1302041110160.11905@ionos> <030401ce02c9$e5139170$af3ab450$@ravellosystems.com> <alpine.LFD.2.02.1302051119470.11905@ionos>
In-Reply-To: <alpine.LFD.2.02.1302051119470.11905@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2013 12:20 PM, Thomas Gleixner wrote:
> On Mon, 4 Feb 2013, Leonid Shatz wrote:
>
>> I assume the race can also happen between hrtimer cancel and start. In both
>> cases timer base switch can happen.
>>
>> Izik, please check if you can arrange the patch in the standard format (do
>> we need to do it against latest kernel version?)
> Yes please.

But I sent it already yasterday with git-send-email and checkpatch.pl :-)

> Thanks,
>
> 	tglx



