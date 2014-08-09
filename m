Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaHISE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 14:04:58 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47933 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbaHISE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 14:04:57 -0400
Date: Sat, 9 Aug 2014 20:04:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Sergey Oboguev <oboguev.public@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
Message-ID: <20140809180455.GA4120@two.firstfloor.org>
References: <8738dm9t4z.fsf@tassilo.jf.intel.com>
 <1406532289.5133.223.camel@marge.simpson.net>
 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
 <1407059776.5156.108.camel@marge.simpson.net>
 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
 <1407303693.5090.171.camel@marge.simpson.net>
 <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
 <1407402199.5141.283.camel@marge.simpson.net>
 <CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
 <1407589454.5156.308.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407589454.5156.308.camel@marge.simpson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK.  There it is, my imaginary NAK to imaginary realtime priorities :)

Ok, but do you have any alternative proposal yourself how to solve the
lockholder preemption problem? I assume you agree it's a real problem.

Just being negative is not very constructive.

-Andi
