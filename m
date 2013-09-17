Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3IQS1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:27:47 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64555 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab3IQS1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:27:46 -0400
Message-ID: <1379442463.31104.11.camel@x220.thuisdomein>
Subject: Re: scsi: delete decade+ obsolete aic7xxx_old driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>, Doug Ledford <dledford@redhat.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Josh Boyer <jwboyer@redhat.com>
Date: Tue, 17 Sep 2013 20:27:43 +0200
In-Reply-To: <1379382683-27862-1-git-send-email-paul.gortmaker@windriver.com>
References: <1379382683-27862-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2013 18:27:44.0051 (UTC) FILETIME=[99D29830:01CEB3D3]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 21:51 -0400, Paul Gortmaker wrote:
> Currently we have people wasting time building it during routine testing,
> and then wasting more time re-researching the known reported warnings,
> only to find that nobody really is willing to integrate the fixes[3] for
> it.
> 
>[...]
>
> [3] https://lkml.org/lkml/2012/10/29/215

Well, this didn't end up as an entire waste of my time. After that
message I sent a patch to Fedora's kernel list, and a reminder a few
months later[1]. That prompted Josh Boyer to remove this old driver from
the Fedora build[2].

And now that driver is disabled in all kernels that Fedora currently
ships. I'm not familiar with any complaints about this decision.


Paul Bolle

[1] https://lists.fedoraproject.org/pipermail/kernel/2013-February/004102.html
[2] http://pkgs.fedoraproject.org/cgit/kernel.git/commit/?id=2192022f4bf13b30e389e77170da7ae08fd28ecf

