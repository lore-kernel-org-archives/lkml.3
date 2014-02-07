Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaBGRel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 12:34:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57905 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaBGRek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 12:34:40 -0500
Date: Fri, 7 Feb 2014 09:35:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCHv2 0/7] Staging fixes from the Android tree (for 3.14)
Message-ID: <20140207173549.GB4983@kroah.com>
References: <1391558920-31590-1-git-send-email-john.stultz@linaro.org>
 <20140207170350.GA18784@kroah.com>
 <52F514FE.705@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F514FE.705@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 09:16:46AM -0800, John Stultz wrote:
> On 02/07/2014 09:03 AM, Greg KH wrote:
> > On Tue, Feb 04, 2014 at 04:08:33PM -0800, John Stultz wrote:
> >> I recently went through the AOSP common.git android/3.10 tree to
> >> try to pull fixes that haven't been submitted upstream. I've
> >> cherry picked those patches and submitted them for 3.15, but
> >> Greg requested the bugfixes to be submitted by themselves for
> >> 3.14.
> >>
> >> So here are the subset of changes that are bugfixes. There is
> >> one additional patch here which I missed in my last submission,
> >> but its a build warning fix, so I think its appropriate.
> >>
> >> If and when these are merged, I'll resubmit the rest of the
> >> queue (which has grown further as of today) for 3.15.
> >>
> >> Anyway, please let me know if there's any feedback or suggestions.
> > I seem to be missing patch 2/7 here.  Any idea where it went?
> 
> Huh. I see it in my lkml archive. The subject is:
> [PATCH 2/7] staging: sync: Signal pt before sync_timeline object gets
> destroyed
> 
> https://lkml.org/lkml/2014/2/4/738
> 
> Maybe check your spam folder? If you need I can bounce it to you again.

Ah, you forgot to cc: me, that's why I didn't get it :)

Got it now, thanks.

greg k-h
