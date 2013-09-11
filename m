Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3IKSu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:50:29 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:43610 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3IKSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:50:26 -0400
Date: Wed, 11 Sep 2013 20:50:10 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, John Stultz <john.stultz@linaro.org>,
        Arun Sharma <asharma@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        Kumar Sundararajan <kumar@fb.com>
Subject: Re: clock_gettime_ns
Message-ID: <20130911185008.GB8759@netboy>
References: <5226FAE1.5070201@fb.com>
 <CALCETrWify68=_bVmFfnTWH5vY3NgxDChr_cvL7v6VovaSJdKA@mail.gmail.com>
 <CANcMJZAi_738t-eDUphC6U_25xFS0NqQqdUZAzu7Aijqmrj=wA@mail.gmail.com>
 <CALCETrVc-3j=7bP13dkYwqxUg77rdauHQ8_KEti0khh-HX220A@mail.gmail.com>
 <52279E1D.3060907@linaro.org>
 <5227B432.8070205@zytor.com>
 <CALCETrWnZnT_t0KkWPo1v1tmPhX5_XKD19ktWL2BvKY-MezkAA@mail.gmail.com>
 <e54aa177-0c72-447b-9c95-26bda8728d08@email.android.com>
 <CALCETrWJbtrC0FDKFQ7_qS8sdxd7LyJk562uAzrK1TJqy97YOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWJbtrC0FDKFQ7_qS8sdxd7LyJk562uAzrK1TJqy97YOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 10:47:01AM -0700, Andy Lutomirski wrote:
> 
> I think that coming up with something that's both non-POSIX and
> half-arsed is a bad idea, but doing something that's non-POSIX and
> well thought-through could be valuable.

I know Harlan Stenn of the Network Time Foundation is working on a new
timestamp API and presented a paper at the conference:

   Requirements for UTC and Civil Timekeeping on Earth
   A Colloquium Addressing a Continuous Time Standard
   University of Virginia, Charlottesville, May 29-31, 2013. 

   http://www.cacr.caltech.edu/futureofutc/

The slides are on that site, and I would bet that the paper could be
made available. In any case, since I think any kind of new time API idea
would benefit from review and acceptance from the NTP and BSD people.

Thanks,
Richard



  
