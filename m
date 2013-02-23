Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3BWVzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:55:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42965 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759258Ab3BWVzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:55:47 -0500
Message-ID: <51293A8B.5060107@zytor.com>
Date: Sat, 23 Feb 2013 13:54:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonas Heinrich <onny@project-insanity.org>
CC: len.brown@intel.com, pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume
References: <20130218155439.GA902@onny> <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com> <20130223131856.GA682@onny>
In-Reply-To: <20130223131856.GA682@onny>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2013 05:18 AM, Jonas Heinrich wrote:
> Hi,
> thank you for your replay and the effort you invest in helping me out
> with this problem.
> Today, I further debuged the problem and reverted this part of your commit
> (without understanding the actual code):
>

Hi, that commit is indeed buggy, but it has already been fixed; commit
1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e contains the fix.

So to bisect anything between 73201dbec64aebf6b0dca855b523f437972dc7bb 
and 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e in a meaningful way you 
will have to apply 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e on top.

If 73201dbec64aebf6b0dca855b523f437972dc7b with 
1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e on top fails whereas the 
previous one does, then that is very interesting and something we can 
work with.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

