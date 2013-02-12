Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448Ab3BLQe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:34:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:28117 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab3BLQez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:34:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290139777"
Date: Tue, 12 Feb 2013 08:10:18 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
Message-ID: <20130212161018.GN3789@intel.com>
References: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CAKohpo=w+LaUf0LMLBJBmEUjShCUzxKrqm5WzcrZmxAyg1vM4g@mail.gmail.com>
 <CAHp75VctZrUh5Vrxtt5XuiHf5_KFXPGkRva1713W=EMmCJUuPQ@mail.gmail.com>
 <CAOh2x=kaUtstcbB+9-rMaxbKv3Nmtxqg2CE4b3Xn0+HHNwOZbw@mail.gmail.com>
 <CAHp75Vc7Y4uLKmBuK5p9O75qEfBjckmEtxmNQLmn7WFNsOBEjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vc7Y4uLKmBuK5p9O75qEfBjckmEtxmNQLmn7WFNsOBEjw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 09:25:11AM +0200, Andy Shevchenko wrote:
> On Fri, Feb 8, 2013 at 6:28 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On Thu, Feb 7, 2013 at 10:35 PM, Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> >> On Thu, Feb 7, 2013 at 5:39 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> >>> On 7 February 2013 21:06, Andy Shevchenko
> >>> <andriy.shevchenko@linux.intel.com> wrote:
> >>>> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> ...
> >>>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >>>
> >>> Looks like Mika is Author and you have your signed-off :)
> >>
> >> In this literally small and clear patch it doesn't matter who is who.
> >
> > I believe it doesn't matter how small or big is the patch, but the author should
> > be there in SOBs too..
> True.
Then in that case you need to re-read Documentation/SubmittingPatches
SOB is also acnowlegement of Origin of the Code, hence mandatory even for single
line of change.
> >
> >> However for sake of equity I could add Mika's signed-off-by as well.
> >>
> >> It should be:
> >> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > Thanks.
> 
> Shall I resend it?
It will fix it up, and thanks to greg now you owe me a beverage :)
> 
> -- 
> With Best Regards,
> Andy Shevchenko
