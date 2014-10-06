Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbaJFRaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:30:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaJFRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:30:34 -0400
Date: Mon, 6 Oct 2014 10:29:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Stevean Rk <rk.stevean@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, m.chehab@samsung.com,
        =?iso-8859-1?Q?ayb=FCke_=F6zdemir?= <aybuke.147@gmail.com>,
        Tapasweni Pathak <tapaswenipathak@gmail.com>,
        paul.gortmaker@windriver.com,
        Monam Agarwal <monamagarwal123@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: media: Added semicolon.
Message-ID: <20141006172936.GA10074@kroah.com>
References: <20141004184316.GA6561@srkjfone>
 <5432489A.60202@xs4all.nl>
 <CAM4Bvj6pAN_5xsjgheJrkMm0W_6oeG0VUDCE+ijAcOV7ojSa2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM4Bvj6pAN_5xsjgheJrkMm0W_6oeG0VUDCE+ijAcOV7ojSa2g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 08:18:28PM +0530, Stevean Rk wrote:
> 
> Its against  3.17.0-rc6+
> I had cloned the Greg Kroah-Hartman's staging tree repository.
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Which branch?  3.17-rc6 is quite old, you need to work against the
staging-next branch in there if you want to send patches that can apply
properly.

thanks,

greg k-h
