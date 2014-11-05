Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbaKEPyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:54:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:25702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaKEPym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:54:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411874962"
Message-ID: <1415202877.958.131.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 06/35] UBI: Fastmap: Ensure that all fastmap work is
 done upon WL shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org
Date: Wed, 05 Nov 2014 17:54:37 +0200
In-Reply-To: <545A46F0.7030805@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
		 <1414586758-9972-7-git-send-email-richard@nod.at>
	 <1415202307.958.125.camel@sauron.fi.intel.com> <545A46F0.7030805@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 16:49 +0100, Richard Weinberger wrote:
> If you want I can rebase.

That would be very helpful.

> I did all fixes first and then the cleanups.

Well, the first patch adds debugging stuff - not exactly a fix ;-)

