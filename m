Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKQMao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:30:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:42774 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaKQMan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="609062536"
Date: Mon, 17 Nov 2014 14:30:39 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141117123039.GB2583@lpalcu-linux>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-2-git-send-email-laurentiu.palcu@intel.com>
 <20141113122728.GA18285@localhost>
 <20141113151721.GQ5826@lpalcu-linux>
 <20141114105645.GB18285@localhost>
 <20141117103300.GA2583@lpalcu-linux>
 <20141117115316.GA19375@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117115316.GA19375@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:53:16PM +0100, Johan Hovold wrote:
> On Mon, Nov 17, 2014 at 12:33:01PM +0200, Laurentiu Palcu wrote:
> > Hi Johan,
> > 
> > On Fri, Nov 14, 2014 at 11:56:45AM +0100, Johan Havold wrote:
> > > On Thu, Nov 13, 2014 at 05:17:21PM +0200, Laurentiu Palcu wrote:
> > > > Hi Johan,
> > > > 
> > > > On Thu, Nov 13, 2014 at 01:27:28PM +0100, Johan Havold wrote:
> > > > > On Wed, Nov 12, 2014 at 03:38:09PM +0200, Laurentiu Palcu wrote:
> 
> > > And since there's no gain from using the global buffer why not simply
> > > use stack allocated ones here as well (e.g. for both tx and rx above)?
> >
> > However, I will give this a shot though... Sounds reasonable and I could
> > probably lose the struct constructs too if the struct contains just
> > one field.
> 
> You might want to keep the structs for single-field messages for
> consistency reasons (also used in the other dln2 subdrivers).
Ok, fair enough.

laurentiu
