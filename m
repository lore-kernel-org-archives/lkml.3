Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3GOEyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 00:54:05 -0400
Received: from 1wt.eu ([62.212.114.60]:34639 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab3GOEyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 00:54:02 -0400
Date: Mon, 15 Jul 2013 06:54:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soeren.brinkmann@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
Message-ID: <20130715045400.GU32054@1wt.eu>
References: <20130715043625.GA2162@skorgonTP.att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130715043625.GA2162@skorgonTP.att.net>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 09:36:25PM -0700, Sören Brinkmann wrote:
> Hi Greg,
> 
> since upgrading to 3.10.1 I find my system not waking up from suspend
> from time to time. Unfortunately, I couldn't figure out how to reliably
> reproduce the issue. Sometimes it works just fine.
> 
> All I know so far:
> On 3.10 I had my system completely freezing a few times. But that did
> not seem to be related to suspend/resume. I never experienced the
> behavior described below on 3.10.
> 
> On 3.10.1 I hit this bug a few times, that my system did not wake up.
> I.e. the screen stayed black and the power LED kept flashing. But
> nothing brought the system back up and I had to longpress power to reset
> the system.
> I had none of the system freezes like the ones described above anymore.

Fortunately, 3.10.1 is very small. The only patch it contains which is
related to suspend is 18/19 (cpufreq ondemand governor). Maybe you're
having a problem with cpufreq on this machine in fact.

You may want to try to force it to performance mode or powersave mode
and try for a while, it is possible that both 3.10 and 3.10.1 will work
fine.

Best regards,
Willy

