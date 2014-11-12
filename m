Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaKLMbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:31:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:36273 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbaKLMbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:31:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,368,1413270000"; 
   d="scan'208";a="621149112"
Message-ID: <1415795489.22887.246.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/4] UBIFS: add ubifs_err() to print error reason
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 12 Nov 2014 14:31:29 +0200
In-Reply-To: <20141111160809.GA11589@bshelton-desktop>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-5-git-send-email-ben.shelton@ni.com>
	 <1415704235.22887.138.camel@sauron.fi.intel.com>
	 <20141111160809.GA11589@bshelton-desktop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 10:08 -0600, Ben Shelton wrote:
> On 11/11, Artem Bityutskiy wrote:
> > Pushed this, but made some amendments.
> > 
> > Now all 4 are in the master branch. Would you please re-test them again
> > and confirm that they are fine. Then I'll push them to the linux-next
> > branch, unless you report that my amendments broke something.
> > 
> > Thank you!
> > 
> 
> Hi Artem,
> 
> I pulled the four modified commits into my 3.18-rc3 branch and tested
> with lockdep enabled.  Everything looks good.

OK, thank you!

