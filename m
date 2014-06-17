Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965755AbaFQQn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:43:57 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57129 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964930AbaFQQny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:43:54 -0400
Message-ID: <1403023431.1984.37.camel@x220>
Subject: Re: [PATCH v3 5/7] mfd: cros_ec: Sync to the latest
 cros_ec_commands.h from EC sources
From: Paul Bolle <pebolle@tiscali.nl>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Simon Glass <sjg@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, Wolfram Sang <wsa@the-dreams.de>,
        Andrew Bresticker <abrestic@chromium.org>,
        Dylan Reid <dgreid@chromium.org>, Olof Johansson <olof@lixom.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jun 2014 18:43:51 +0200
In-Reply-To: <53A06AD4.3000704@wwwdotorg.org>
References: <1398879850-9111-1-git-send-email-dianders@chromium.org>
		 <1398879850-9111-6-git-send-email-dianders@chromium.org>
		 <20140520084602.GF24991@lee--X1> <1402483068.3798.82.camel@x220>
		 <CAD=FV=XL9tnEqza8Zx8mt_Z7-bj8TCzdeyHMhnpewKp_1CR-ig@mail.gmail.com>
		 <1402646902.28881.15.camel@x220>
		 <CAD=FV=XcK5R1sdNwoJkFPapwWQ9vqxvmQi_L3BqTSt8EKRTNHw@mail.gmail.com>
	 <1402995202.1984.22.camel@x220> <53A06AD4.3000704@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2014 16:43:51.0930 (UTC) FILETIME=[51F625A0:01CF8A4B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 10:20 -0600, Stephen Warren wrote:
> On 06/17/2014 02:53 AM, Paul Bolle wrote:
> > So, in summary, while we're apparently only discussing a single comment,
> > I would appreciate it if it could be reworded, preferably by dropping
> > that the CONFIG_ prefix. But other people might care very little, as
> > they don't share this particular pet peeve.
> 
> Can't your tool maintain a whitelist or ignore list?

Sure it can. But I do think I should try to fix the (in my view, at
least) problems I find before adding stuff to a whitelist or (whatever).

> There are many
> cases where the kernel can pull in headers/data from other projects
> (Firmware interfaces to an arbitrarily large set of HW, Device trees,
> IO/network protocools, perhaps more). It feels quite unreasonable for
> the kernel to decide that it exclusively owns the CONFIG_* namespace
> even in comments, and that every other project it interacts with must
> not use that namespace.

As I said, this is more my peeve. Then again, referring to a macro from
some other project is likely to confuse people.


Paul Bolle

