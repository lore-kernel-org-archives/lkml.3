Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbaIXJpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:12691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaIXJpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,588,1406617200"; 
   d="scan'208";a="604557920"
Date: Wed, 24 Sep 2014 12:45:01 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [RFC PATCH v2 00/16] Add ACPI _DSD and unified device properties
 support
Message-ID: <20140924094501.GY1786@lahna.fi.intel.com>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com>
 <1582936.0FiE8Cvqie@vostro.rjw.lan>
 <20140924083418.GH17801@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924083418.GH17801@lee--X1>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:34:18AM +0100, Lee Jones wrote:
> I'd prefer to take the MFD patch through the MFD tree if that's
> possible.  Are there any technical reasons why this would prove
> difficult?

I don't see any reasons why it cannot be taken via MFD tree.
