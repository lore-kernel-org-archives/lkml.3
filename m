Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3FTSM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:12:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39138 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756845Ab3FTSMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:12:55 -0400
Message-ID: <1371751974.2146.21.camel@joe-AO722>
Subject: Re: [RFC PATCH] led: add Cycle LED trigger.
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?Ga=EBl?= PORTAY <g.portay@overkiz.com>
Cc: Rob Landley <rob@landley.net>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        "Milo(Woogyom) Kim" <milo.kim@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org
Date: Thu, 20 Jun 2013 11:12:54 -0700
In-Reply-To: <51C2CF0B.1010007@overkiz.com>
References: <1371572663-10846-1-git-send-email-g.portay@overkiz.com>
	 <1371593140.2038.8.camel@joe-AO722> <51C2CF0B.1010007@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 11:44 +0200, Gaël PORTAY wrote:
> On 19/06/2013 00:05, Joe Perches wrote:
> > On Tue, 2013-06-18 at 18:24 +0200, Gaël PORTAY wrote:
> >> Currently, none of available triggers supports playing with the LED brightness
> >> level.  The cycle trigger provides a way to define custom brightness cycle.
[]
> > I think maybe this is a userspace thing,
[]
> About the kernel/user space discussion, I'd rather keep the cycle 
> trigger implementation in the kernel space,
> because it implies brightness change every 10-100ms or less. This leads 
> to lots of context switches, and I'm not
> even sure the user space can handle such timings accurately.

Hi Gaël

No big concern other than maybe that's best done
in user space.  Try it.  If it doesn't work well,
then send the kernel patch with a description why
it doesn't work well in user-space.

cheers, Joe

