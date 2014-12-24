Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584AbaLXQqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 11:46:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35314 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaLXQqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 11:46:02 -0500
Date: Wed, 24 Dec 2014 17:46:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, yoongukim@cmu.edu,
        donghyu1@cmu.edu, omutlu@gmail.com
Subject: Re: DRAM unreliable under specific access patern
Message-ID: <20141224164600.GA20268@amd>
References: <20141224163823.GA17035@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141224163823.GA17035@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(I added original researches to the list).

I see you have FPGA-based detector, and probably PC based detector,
too. Would it be possible to share sources of the PC based one?

Thanks,
								Pavel

On Wed 2014-12-24 17:38:23, Pavel Machek wrote:
> Hi!
> 
> It seems that it is easy to induce DRAM bit errors by doing repeated
> reads from adjacent memory cells on common hw. Details are at
> 
> https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
> 
> . Older memory modules seem to work better, and ECC should detect
> this. Paper has inner loop that should trigger this.
> 
> Workarounds seem to be at hardware level, and tricky, too.
> 
> Does anyone have implementation of detector? Any ideas how to work
> around it in software?
> 									
> 									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
