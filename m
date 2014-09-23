Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbaIWSqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:46:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:56446 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302AbaIWSqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:46:15 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 14:46:15 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,581,1406617200"; 
   d="scan'208";a="577726618"
Date: Tue, 23 Sep 2014 21:36:29 +0300
From: "Westerberg, Mika" <mika.westerberg@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Loic Poulain <loic.poulain@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Samuel Ortiz <samuel.ortiz@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
Message-ID: <20140923183629.GU1786@lahna.fi.intel.com>
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
 <CACRpkdYfMNVeK_X_oQFTnDwyZ_ZemUw3SBL0_JJvpToRXgdFSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYfMNVeK_X_oQFTnDwyZ_ZemUw3SBL0_JJvpToRXgdFSg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 05:44:43PM +0200, Linus Walleij wrote:
> On Wed, Sep 17, 2014 at 3:47 PM, Loic Poulain <loic.poulain@intel.com> wrote:
> 
> > Direct Irq En bit can be initialized to a bad value.
> > This bit has to be cleared for io access mode.
> >
> > Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> > ---
> >  v2: Apply over ff998356b644ebe723127bd9eec6040b59a4a4f6 + add Warning
> 
> I can't figure out if the maintainers like this patch or not.
> 
> If you want it applied, please ACK it explicitly.

I would like to get a bit better information in the changelog and the
warning message should be more informative. I'll ACK it after that is
done.

Loic, are you going to do that?
