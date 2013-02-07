Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab3BGPSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:18:23 -0500
Received: from wolff.to ([65.117.131.163]:42090 "HELO wolff.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758579Ab3BGPSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:18:13 -0500
Date: Thu, 7 Feb 2013 09:17:34 -0600
From: Bruno Wolff III <bruno@wolff.to>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with late 3.8-rc5 and 3.8-rc6 on i686
Message-ID: <20130207151734.GA25070@wolff.to>
References: <20130201201332.GA2965@wolff.to>
 <20130207015259.GA760@wolff.to>
 <CA+5PVA5H0merTWq=wAe38m2WPg1_A06saHcST+VUfgkk9OuSOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+5PVA5H0merTWq=wAe38m2WPg1_A06saHcST+VUfgkk9OuSOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 08:37:01 -0500,
   Josh Boyer <jwboyer@gmail.com> wrote:
>
>Anyway, still seems to me that systemd/rtkit-daemon should be _checking_
>to see if that feature is present instead of assuming it is and failing
>in weird ways when it isn't.

I agree. It would have been a lot quicker to figure this out if there had 
been a message that plainly stated that namespaces weren't available and 
either ignored the privatenamespace setting or failed, but suggested turning 
the setting off.
