Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbaLHK5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 05:57:40 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:44666 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761AbaLHK5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 05:57:37 -0500
Date: Mon, 8 Dec 2014 11:57:32 +0100
From: Johan Hovold <johan@kernel.org>
To: Octavian Purdila <octavian.purdila@intel.com>
Cc: Johan Hovold <johan@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: dln2: add suspend/resume functionality
Message-ID: <20141208105732.GA14346@localhost>
References: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
 <20141205101741.GD11445@localhost>
 <CAE1zotJwn6kVv8s5Dk+wxQxuGDKSjaqMqYY0M0Q0uODQypSsoA@mail.gmail.com>
 <20141205120610.GG11445@localhost>
 <CAE1zotKGAvd9oKz5_McihnPcpH-n4Rc4s0r=jm2wb26-dD8Dsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1zotKGAvd9oKz5_McihnPcpH-n4Rc4s0r=jm2wb26-dD8Dsg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 03:05:45PM +0200, Octavian Purdila wrote:
> On Fri, Dec 5, 2014 at 2:06 PM, Johan Hovold <johan@kernel.org> wrote:
> > On Fri, Dec 05, 2014 at 01:51:17PM +0200, Octavian Purdila wrote:
> >> On Fri, Dec 5, 2014 at 12:17 PM, Johan Hovold <johan@kernel.org> wrote:

> >> > And surely you need to resubmit the read urbs in resume, or you will
> >> > never receive any more data.
> >> >
> >> > How did you test this patch?
> >> >
> >>
> >> The resume cb is not called in my setup (kvm), only reset_resume.
> >
> > Please make sure to test your patches on proper hardware.
> 
> It was tested with the proper hardware, I was just testing it in the
> setup we use, which is kvm with USB pass through.

I was referring to your kvm setup.

Johan
