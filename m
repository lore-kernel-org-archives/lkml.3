Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbbAFAaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 19:30:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:17574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbbAFAaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 19:30:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,702,1413270000"; 
   d="scan'208";a="657246848"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Topic: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Thread-Index: AQHQKNIe6YwEecfkn02ZwABJi6oKXZyyPR8A
Date: Tue, 6 Jan 2015 00:30:05 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E88026AB06A@SHSMSX101.ccr.corp.intel.com>
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
	<1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
	<1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
 <87oaqdy13n.fsf@rasmusvillemoes.dk>
In-Reply-To: <87oaqdy13n.fsf@rasmusvillemoes.dk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> Sent: Monday, January 05, 2015 6:27 PM
> 
> On Mon, Jan 05 2015, "Zheng, Lv" <lv.zheng@intel.com> wrote:
> 
> > Hi,
> >
> >> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
> >> Sent: Friday, December 12, 2014 6:51 PM
> >> To: Zheng, Lv
> >> Cc: Rasmus Villemoes; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
> >> Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
> >>
> >> The macro __DATE__ and friends is not allowed in the kernel. Also,
> >> including the build time in output doesn't seem to provide any value.
> >>
> >
> > Could you confirm that it is not useful even for the user tools?
> > Please perform the following commands in the kernel source tree
> > 1. stay in tools folder
> > 2. type "make acpi"
> > 3. type "./power/acpi/acpidump -v"
> >
> 
> Yeah, it's part of the output, but for what reason? What can userspace
> possibly use that information for?

I also want to know.

> I can see some utility in printing a
> version number, since that may tell something about the features
> present or absent. The compilation date, on the other hand, seems
> completely useless. Different distros may ship different versions which
> happened to be compiled on the same day, or older versions compiled later.

If the deletion was done for this reason, IMO, it's acceptable.
So let's wait to see others' feedback.

Thanks and best regards
-Lv

> Note that -Werror=date-time was added to the kernel's default build
> flags in fe7c36c7bde12. It doesn't currently show because tools/ uses
> its own flags, and the ACPI_COMMON_SIGNON macro is not used within the
> kernel.
> 
> Rasmus
