Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaLESLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:11:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:21285 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLESLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:11:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,523,1413270000"; 
   d="scan'208";a="643123348"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Streetman <ddstreet@ieee.org>, Jennings <sjennings@variantweb.net>,
        "Yokoyama\, Caz" <caz.yokoyama@intel.com>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "Chandramouli\, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Rao\, Nikhil" <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH linux-next] Documentation: Build mic/mpssd only for x86_64
References: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
	<20141205111818.551a870f@lwn.net>
Date: Fri, 05 Dec 2014 10:26:46 -0800
In-Reply-To: <20141205111818.551a870f@lwn.net> (Jonathan Corbet's message of
	"Fri, 5 Dec 2014 09:18:18 -0700")
Message-ID: <m3egse7y1l.fsf@adixit-yct.ra.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05 2014 at 08:18:18 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Thu,  4 Dec 2014 13:27:29 -0800
> Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:
>
>> mic/mpssd along with MIC drivers are currently only usable on
>> x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
>> big-endian systems.
>
> I can certainly apply this.  But it seems to me that this kind of code
> doesn't belong in the documentation directory.  How about a patch to move
> it to tools/ ?

Yes, let's resolve the situation for now and then we'll submit another
patch soon to move it to tools.
