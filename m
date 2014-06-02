Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaFBKOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:14:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50146 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943AbaFBKOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:14:19 -0400
Date: Mon, 2 Jun 2014 13:13:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: DaeSeok Youn <daeseok.youn@gmail.com>
Cc: Lidza Louina <lidza.louina@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        devel <devel@driverdev.osuosl.org>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6 RESEND] staging: dgap: remove useless dgap_probe1()
 function
Message-ID: <20140602101327.GU17724@mwanda>
References: <20140602050358.GA29799@devel.8.8.4.4>
 <20140602073037.GR15585@mwanda>
 <CAHb8M2BE+Nn0L3o1nWFbg0XCor8CUDB+1YxdzHAxfWXhFnLHYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHb8M2BE+Nn0L3o1nWFbg0XCor8CUDB+1YxdzHAxfWXhFnLHYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 06:35:15PM +0900, DaeSeok Youn wrote:
> Hi, Dan.
> 
> 2014-06-02 16:30 GMT+09:00 Dan Carpenter <dan.carpenter@oracle.com>:
> > On Mon, Jun 02, 2014 at 02:03:58PM +0900, Daeseok Youn wrote:
> >> The dgap_probe1() function is just calling dgap_found_board().
> >> So it is removed and dgap_found_board() is called directly.
> >>
> >> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> >> ---
> >> RESEND : this patch is included into newly serise of patches
> >> so renumbered and resend.
> >
> > Don't do this.  Just assume that patch will be applied.  Greg applies
> > patches in first come, first serve order.  If it doesn't apply then he
> > sends an email to redo it.
> Ok. I will not do like this again. sorry,
> I should wait for merge first two patches or send my patches
> without the first two patches.

Don't bother waiting.  Just send the next patches.  The first ones were
good patches, so Greg will apply them.  It is a very predictable
process.

regards,
dan carpenter

