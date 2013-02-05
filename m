Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab3BEKj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 05:39:57 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:44913 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751156Ab3BEKj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 05:39:56 -0500
X-Greylist: delayed 323 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2013 05:39:55 EST
MIME-Version: 1.0
X-Originating-IP: [85.250.45.135]
In-Reply-To: <alpine.LFD.2.02.1302051119470.11905@ionos>
References: <510E58C2.9010207@ravellosystems.com>
	<alpine.LFD.2.02.1302041110160.11905@ionos>
	<030401ce02c9$e5139170$af3ab450$@ravellosystems.com>
	<alpine.LFD.2.02.1302051119470.11905@ionos>
Date: Tue, 5 Feb 2013 12:34:31 +0200
Message-ID: <CAF1J0HN4YO9cTCkwwznMVH7-ui3EZAG1y8+9xm+bDJrTZrq7VA@mail.gmail.com>
Subject: Re: hrtimer possible issue
From: Mike Rapoport <mike.rapoport@ravellosystems.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Leonid Shatz <leonid.shatz@ravellosystems.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

On Tue, Feb 5, 2013 at 12:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Mon, 4 Feb 2013, Leonid Shatz wrote:
>
>> I assume the race can also happen between hrtimer cancel and start. In both
>> cases timer base switch can happen.
>>
>> Izik, please check if you can arrange the patch in the standard format (do
>> we need to do it against latest kernel version?)
>
> Yes please.

The patch is here: https://patchwork.kernel.org/patch/2091501/

> Thanks,
>
>         tglx

-- 
Sincerely yours,
Mike.
