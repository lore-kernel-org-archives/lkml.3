Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229AbaDJJad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:30:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56681 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbaDJJaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:30:25 -0400
Date: Thu, 10 Apr 2014 11:30:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jason Baron <jbaron@akamai.com>, Aristeu Rozanski <aris@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "mitake@dcl.info.waseda.ac.jp" <mitake@dcl.info.waseda.ac.jp>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ie31200_edac: Add driver
Message-ID: <20140410093017.GE29093@pd.tnic>
References: <20140409133433.GJ29214@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F31E22EAC@ORSMSX106.amr.corp.intel.com>
 <20140409173633.GN6529@pd.tnic>
 <5345980F.7070604@akamai.com>
 <20140409191454.GQ6529@pd.tnic>
 <5345A54D.2050808@akamai.com>
 <20140409201615.GS6529@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31E2358F@ORSMSX106.amr.corp.intel.com>
 <5345C683.2080307@akamai.com>
 <3908561D78D1C84285E8C5FCA982C28F31E237A2@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31E237A2@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:44:21PM +0000, Luck, Tony wrote:
> Scenario: Your mission critical app is running (controlling a giant
> laser cutter). Oops there is a memory error, and the bad data arrives
> at the application causing it to swing the laser beam through 180
> degrees, destroying half of your lab. A few seconds/minutes later -
> your EDAC driver prints a message saying that the uncorrected error
> count just got incremented.

LOL, that sounds like an episode from some cartoon movie with a nutty
professor with thick glasses in it. On the equipment boilerplate it says
ACME^WEDAC.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
