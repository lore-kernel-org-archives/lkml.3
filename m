Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3EPKap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 06:30:45 -0400
Received: from canardo.mork.no ([148.122.252.1]:43064 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab3EPKam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 06:30:42 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Schmiedl Christian <Christian.Schmiedl@gemalto.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Schemmel Hans-Christoph <Hans-Christoph.Schemmel@gemalto.com>
Subject: Re: [PATCH] qmi_wwan: Added support for Cinterion's PLxx WWAN Interface
Organization: m
References: <376FB829F3ECB542B825EAF4D8CA8A97012A579993A9@CROEXCFWP03.gemalto.com>
Date: Thu, 16 May 2013 12:30:21 +0200
In-Reply-To: <376FB829F3ECB542B825EAF4D8CA8A97012A579993A9@CROEXCFWP03.gemalto.com>
	(Schmiedl Christian's message of "Wed, 15 May 2013 15:44:46 +0200")
Message-ID: <871u97fc8y.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schmiedl Christian <Christian.Schmiedl@gemalto.com> writes:

> /drivers/net/usb/qmi_wwan.c: Added support for Cinterion's PLxx WWAN Interface
> by adding QMI_FIXED_INTF with Cinterion's Vendor ID as well as Product ID and
> WWAN Interface Number.

Much better.  But this patch need to go to the netdev list to get picked
up by the net patchworks and maintainer.  It was posted there the last
time, so I don't understand why you dropped that now?  The minimum To/Cc
list for usbnet drivers is:

 netdev@vger.kernel.org, linux-usb@vger.kernel.org

Anything else is a bonus, and adding linux-kernel is of course fine.
Hint:  Use linux/scripts/get_maintainer.pl to get a list of addresses to
send a patch to.

> Signed-off-by: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>
> Signed-off-by: Christian Schmiedl <christian.schmiedl@gemalto.com>

This is of course fine, but the patch was sent by Hans-Christoph the
last time.  If he is the original author, then you also want to preserve
that authorship in the git history (in addition to those SOBs).  The
proper way to do that is to add a line like this as the first line of
the email body, followed by a single empty line:

From: Hans-Christoph Schemmel <hans-christoph.schemmel@gemalto.com>

This will make "git am" use Hans-Christoph as the author, even if the
patch is posted by you.

And since you obviously have to resend this anyway: Please drop the file
name ("/drivers/net/usb/qmi_wwan.c: ") from the commit message.  It is
part of the patch itself, and including it in the commit message just
adds noise.


Thanks,
Bjørn
