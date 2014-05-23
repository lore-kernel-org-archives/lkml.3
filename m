Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaEWSxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:53:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44555 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaEWSxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:53:34 -0400
Date: Sat, 24 May 2014 03:47:23 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Colin Cross <ccross@android.com>, devel@driverdev.osuosl.org,
        Linux-MM <linux-mm@kvack.org>, John Stultz <john.stultz@linaro.org>,
        Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: ion: WARN when the handle kmap_cnt is going to
 wrap around
Message-ID: <20140523184723.GA5355@kroah.com>
References: <1400806281-32716-1-git-send-email-mitchelh@codeaurora.org>
 <CAMbhsRQpR-Q=kgr92ezauBj200_2cfnsXHkk+3oPD51ZKD=4RQ@mail.gmail.com>
 <vnkw61kws5rg.fsf@mitchelh-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vnkw61kws5rg.fsf@mitchelh-linux.qualcomm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 11:34:59AM -0700, Mitchel Humpherys wrote:
> ++greg-kh and devel@driverdev.osuosl.org
> (my bad for missing you the first time around)

What can I do with this?  Please send patches to me in a format that I
can actually apply them in...

thanks,

greg k-h
