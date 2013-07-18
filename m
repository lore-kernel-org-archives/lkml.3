Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3GRTqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:46:31 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:41067 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759194Ab3GRTqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:46:30 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArlmAFNF6FFV5qu1PGdsb2JhbABagwaDIiOFALh/BAGBEhcDAQEBATg1giUBBTocGAsQCAMhJQ8FJQoaiCe2FxaOXIEdB4MObgOXXIYzg3CKPzo
X-IronPort-AV: E=Sophos;i="4.89,696,1367964000"; 
   d="scan'208";a="586775324"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 21:47:39 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: Atmel updates to atmel_mxt_ts touch controller driver - v6
Message-ID: <20130718194739.GA559@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

First: thanks for the patches and you work on this driver.

Now, I don't swear much, but I would like to emphasize line 161 of
Documentation/SubmittingPatches:

**Do not send more than 15 patches at once to the vger mailing lists!!!***

One reason that should be obvious by now is that your work will be
attended to much quicker. One may think that it is more efficient to
send the whole backlog at once, but in fact, the time it takes to get
a patchset accepted is inversely proportional to the length of the
patchset. So please, keep it small and simple next time,

Thanks,
Henrik
