Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3GYOAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 10:00:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:53279 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3GYOAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 10:00:38 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-f9-51f12f844c1a
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, konrad.wilk@oracle.com,
        Cristian =?ISO-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        bob.liu@oracle.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH staging] zcache: fix "zcache=" kernel parameter
Date: Thu, 25 Jul 2013 16:00:24 +0200
Message-id: <1791615.801QlVEO5P@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <20130724180246.GA28055@kroah.com>
References: <1954608.bCh4ljCYe6@amdc1032> <20130724180246.GA28055@kroah.com>
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=iso-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsVy+t9jQd0W/Y+BBlcPmVh0nZrKYnHv3zQm
	iz1nfrFbNC9ez2axbPFTRouzTW/YLS7vmsNm8ar5O6vFqkVRDpwe9/YdZvHYP3cNu8exky9Z
	PT4+vcXicfDdHiaPvi2rGD3OLDjC7vF5k1wARxSXTUpqTmZZapG+XQJXxu17KxgL2jgrLj+8
	zdbAOIW9i5GTQ0LARGLD5GesELaYxIV769m6GLk4hASmM0o0//3IAuG0MEl82LOWGaSKTcBK
	YmL7KkYQW0RAQ+Ll0VtgRcwCy5kkFq6bwgSSEBZwllj/+BeYzSKgKrFm2RQ2EJtXQFPiZO9h
	sEGiAq4S5xb9YAGxOQX0JTY0XwM7Q0jAR6L3ejcjRL2gxI/J98BqmAW0JZ68u8AKYetI9H7/
	xjyBUWAWkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Mp5J72Bc1WBx
	iFGAg1GJh3fF9/eBQqyJZcWVuYcYJTiYlUR4Nyp+DBTiTUmsrEotyo8vKs1JLT7EKM3BoiTO
	e7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAyH9lwncpHsmZCZdn+fwyXX54sYjRvesZ0yoSbELb
	G1JCjp2cvf5OnH3y1N/Lj0hYfvys66fjt6ldbcmZxfs6fNY5rO5dIcz2Vbx1tqResNMcETW5
	l6FuVqZOZg+X+p5nqtZ1ZnGxULQOYbZ5fIdzya3ra6Sq0z3eqqh/1VuZOHfzpvUNou80lFiK
	MxINtZiLihMBa/yOMogCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 24, 2013 11:02:46 AM Greg KH wrote:
> On Wed, Jul 24, 2013 at 07:04:14PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > From: Piotr Sarna <p.sarna@partner.samsung.com>
> > Subject: [PATCH] zcache: fix "zcache=" kernel parameter
> 
> What's with the duplicated Subject: line here?  Why?  That means the
> From: line there will probably not get recognized by git (well, it
> might), but then the subject is duplicated again, just like Linus has
> complained about not doing in the past.

Uh, sorry about that.

> And in a mime-encoded format?  Ugh, please fix your email client and
> send it again (yes, git can handle it, but it's a pain at times...)

This seems to be some bug in my version of KMail (it gets confused on
"í" character). I've used git send-email this time.

> third time's a charm?

I hope that the patch is OK now (BTW I applied Michal's ACK that come
in the meantime so there is some positive side of the delay ;).

Once again sorry for the bad patch format and thanks for the patience.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

