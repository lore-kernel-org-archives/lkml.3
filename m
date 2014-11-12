Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaKLMcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:32:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:35558 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbaKLMcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:32:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,368,1413270000"; 
   d="scan'208";a="606548141"
Message-ID: <1415795552.22887.247.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 12 Nov 2014 14:32:32 +0200
In-Reply-To: <54626835.40503@nod.at>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
			 <5460F7D8.2030100@nod.at> <5461C5AD.5040705@nod.at>
		 <1415707434.22887.158.camel@sauron.fi.intel.com> <5462003C.9090509@nod.at>
	 <1415712477.22887.172.camel@sauron.fi.intel.com> <54626835.40503@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 20:49 +0100, Richard Weinberger wrote:
> > I am OK with removing function names from warnings and errors, though.
> > But they were there since the very beginning, and changing this is a
> > separate subject, so I'd prefer someone else to submit a corresponding
> > patch.
> 
> If we keep the function names away from ubi_msg() I'm perfectly fine. :-)

OK, I'm pushing the patch I sent.

