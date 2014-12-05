Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaLESBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 13:01:15 -0500
Received: from mga03.intel.com ([134.134.136.65]:8691 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaLESBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 13:01:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,523,1413270000"; 
   d="scan'208";a="649054920"
From: Ashutosh Dixit <ashutosh.dixit@intel.com>
To: Dan Streetman <ddstreet@ieee.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Jiri Kosina <jkosina@suse.cz>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jennings <sjennings@variantweb.net>,
        "Yokoyama\, Caz" <caz.yokoyama@intel.com>,
        "Dutt\, Sudeep" <sudeep.dutt@intel.com>,
        "Chandramouli\, Dasaratharaman" 
	<dasaratharaman.chandramouli@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "Rao\, Nikhil" <nikhil.rao@intel.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linuxppc-dev\@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Siva Yerramreddy <yshivakrishna@gmail.com>
Subject: Re: [PATCH linux-next] Documentation: Build mic/mpssd only for x86_64
References: <25c04eb72c621fc9bdf0aae25782ff5bad5a4b97.1417728278.git.ashutosh.dixit@intel.com>
	<CALZtONBUDyN7OOMV9ziDXMhFN9+bOcsYvJ0an_7T0VV0Hz+8WQ@mail.gmail.com>
Date: Fri, 05 Dec 2014 10:18:57 -0800
In-Reply-To: <CALZtONBUDyN7OOMV9ziDXMhFN9+bOcsYvJ0an_7T0VV0Hz+8WQ@mail.gmail.com>
	(Dan Streetman's message of "Thu, 4 Dec 2014 20:27:06 -0700")
Message-ID: <m3iohq7yem.fsf@adixit-yct.ra.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04 2014 at 07:27:06 PM, Dan Streetman <ddstreet@ieee.org> wrote:
> On Thu, Dec 4, 2014 at 4:27 PM, Ashutosh Dixit <ashutosh.dixit@intel.com> wrote:
>> mic/mpssd along with MIC drivers are currently only usable on
>> x86_64. So build mic/mpssd only for x86_64 to avoid build breaks on
>> big-endian systems.
>
> Only building for x86_64 is fine, but in that case what's the point of
> leaving the htole16() et. al. functions in mpssd.c?  Shouldn't they be
> removed?

I am hoping that once glibc is fixed we can remove this limitation on
building only for x86_64, so I'd rather htole16() et. al. stayed.  As I
said earlier, I'm fine with your patch too, but restricting the build
for x86_64 seems to be the smallest patch which provides an acceptable
solution.
