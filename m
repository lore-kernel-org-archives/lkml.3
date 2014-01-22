Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaAVE64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 23:58:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaAVE6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 23:58:55 -0500
Date: Tue, 21 Jan 2014 20:59:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj38.park@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: export __clk_get_hw for re-use in others
Message-ID: <20140122045937.GB23869@kroah.com>
References: <1390110907-29918-1-git-send-email-sj38.park@gmail.com>
 <20140119173712.GA26481@kroah.com>
 <CAPtuhTikj38yKy-=uF7O+VFG_N4AWee23f9woemM318fM3V4VQ@mail.gmail.com>
 <CAEjAshoh5ucPJA6pG1sx+7HGCYjHzCKtbzmH+GYJwpefDYLwJg@mail.gmail.com>
 <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEjAshozB4S0ZGqEn41ROfZwGTV+_GZRRTZ8cssi0VdH8Uhr_w@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 12:05:57PM +0900, SeongJae Park wrote:
> Dear Greg, Mike,
> 
> May I ask your answer or other opinion, please?

It's the middle of the merge window, it's not time for new development,
or much time for free-time for me, sorry.  Feel free to fix it the best
way you know how.

greg k-h
