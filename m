Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaBSKGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:06:18 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:61502 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751825AbaBSKFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:05:50 -0500
X-Greylist: delayed 801 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Feb 2014 05:05:49 EST
Message-ID: <1392804347.27558.20.camel@x220>
Subject: Re: [PATCH] target_core_alua: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        scsi <linux-scsi@vger.kernel.org>,
        target-devel <target-devel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Feb 2014 11:05:47 +0100
In-Reply-To: <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	 <1392803546.27558.16.camel@x220>
	 <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Feb 2014 10:05:47.0601 (UTC) FILETIME=[290C4410:01CF2D5A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-02-19 at 10:59 +0100, Geert Uytterhoeven wrote:
> On Wed, Feb 19, 2014 at 10:52 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > -               ret = core_alua_state_nonoptimized(cmd, cdb,
> > -                                       nonop_delay_msecs, &alua_ascq);
> > +               core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);
> 
> I suggest making core_alua_state_nonoptimized()  return void, too.
> Currently it always returns zero.

Good catch. Not sure how I missed that, since I deliberately ignore its
return value here.

I'll wait with sending a v2 until after Nicholas or the other target
developers have given their feedback.


Paul Bolle

