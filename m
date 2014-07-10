Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbaGJAfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:35:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaGJAfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:35:39 -0400
Date: Wed, 9 Jul 2014 17:40:04 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>,
        Paul Bolle <pebolle@tiscali.nl>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Francois.Bedard@synopsys.com
Subject: Re: [PATCH v2 REBASED 00/10] Generic earlyconsole for ARC UART Driver
Message-ID: <20140710004004.GB4950@kroah.com>
References: <1403598315-1429-1-git-send-email-vgupta@synopsys.com>
 <CAL_JsqJF-a3K+dUHpwgSLNrwZTHLp2uj44bZaNboVpTtc8a-RA@mail.gmail.com>
 <53B65255.9000303@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B65255.9000303@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:35:57PM +0530, Vineet Gupta wrote:
> Hi Greg,
> 
> On Wednesday 25 June 2014 02:35 AM, Rob Herring wrote:
> > On Tue, Jun 24, 2014 at 3:25 AM, Vineet Gupta
> > <Vineet.Gupta1@synopsys.com> wrote:
> >> Hi,
> >>
> >> This is slightly modified repost of series posted last week
> >> http://www.spinics.net/lists/linux-serial/msg12884.html
> >>
> >> This series switches ARC UART from custom earlyprintk support to generic
> >> earlycon (many thanks to Rob for doing that). And also build on Grant's recent
> >> work for using DT stdout-path as default console.
> >>
> >> The motivation is to get rid of the early platform code, which in turn
> >> would help consolidate the init code across several ARC platforms.
> >>
> >> First 3 patches are general cleanup/refactoring, not necesarily related to
> >> earlycon.
> > 
> > Other than my comment on patch 6:
> > 
> > Reviewed-by: Rob Herring <robh@kernel.org>
> 
> Is something else needed for this to me merged in tty-next for 3.17.
> I've had only 1 minor comment from Rob, and my reply to him never reached completion.

I'll look at these in a few days...

