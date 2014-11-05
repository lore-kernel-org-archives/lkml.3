Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaKEQGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:06:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:54341 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949AbaKEQGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:06:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411882415"
Message-ID: <1415203535.958.137.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 06/35] UBI: Fastmap: Ensure that all fastmap work is
 done upon WL shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 18:05:35 +0200
In-Reply-To: <545A4947.4030403@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
			 <1414586758-9972-7-git-send-email-richard@nod.at>
		 <1415202307.958.125.camel@sauron.fi.intel.com> <545A46F0.7030805@nod.at>
	 <1415202877.958.131.camel@sauron.fi.intel.com> <545A4947.4030403@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 16:59 +0100, Richard Weinberger wrote:
> Am 05.11.2014 um 16:54 schrieb Artem Bityutskiy:
> > On Wed, 2014-11-05 at 16:49 +0100, Richard Weinberger wrote:
> >> If you want I can rebase.
> > 
> > That would be very helpful.
> > 
> >> I did all fixes first and then the cleanups.
> > 
> > Well, the first patch adds debugging stuff - not exactly a fix ;-)
> 
> Let's name it robustness stuff. ;)
> Seriously, I did first all fixes and the code cleanups later to make
> it easy for others to backport these fixes.

Less back-porting efforts is a good goal. But then the robustness patch
should also come later, I think.

