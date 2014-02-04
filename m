Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbaBDEPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:15:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49971 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbaBDEO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:14:59 -0500
Date: Tue, 4 Feb 2014 03:06:49 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Greg Hackmann <ghackmann@google.com>,
        Prakash Kamliya <pkamliya@codeaurora.org>,
        Alistair Strachan <alistair.strachan@imgtec.com>,
        Todd Poynor <toddpoynor@google.com>,
        Mitchel Humpherys <mitchelh@codeaurora.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 00/16] [RFC] Staging updates from the Android tree
Message-ID: <20140204020649.GA16532@kroah.com>
References: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391451388-23906-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 10:16:12AM -0800, John Stultz wrote:
> I recently went through the AOSP common.git android/3.10 tree to
> try to pull fixes that haven't been submitted upstream. I've
> cherry picked those patches and wanted to submit them here for
> review, and for hopeful inclusion into staging for 3.15.
> 
> In most cases the patches cherry-picked right over. In a few cases,
> there were collisions due to trivial changes and cleanups like
> spelling fixes. However, the "ion: Move shrinker out of heaps"
> patch required more complicated merge, due to the shrinker api
> change upstream in 3.12.  Things build and appear to work, but
> I'd appreciate extra review there.
> 
> Anyway, please let me know if there's any feedback or suggestions. 

As this series is ordered, I can't take any of them for 3.14-final
(patch 1 is a cleanup patch, not for 3.14.)

Care to make 2 series, one for things you feel should be in 3.14 (i.e.
bugfixes), and the other for what can wait for 3.15 (i.e. uapi header
file stuff)?

thanks,

greg k-h
