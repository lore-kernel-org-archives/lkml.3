Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaG0XwH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:52:07 -0400
Received: from unicorn.mansr.com ([81.2.72.234]:43091 "EHLO unicorn.mansr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaG0XwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:52:03 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: of: Make OF_DYNAMIC user selectable
References: <20140728093526.38d8e732@canb.auug.org.au>
Date: Mon, 28 Jul 2014 00:51:58 +0100
In-Reply-To: <20140728093526.38d8e732@canb.auug.org.au> (Stephen Rothwell's
	message of "Mon, 28 Jul 2014 09:35:26 +1000")
Message-ID: <yw1xegx6742p.fsf@unicorn.mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Grant,
>
> I noticed the subject commit in the devicetree tree in linux-next today.
> The commit message gives us no idea why we would want to make this
> change.  We already have lots of user selectable CONFIG_ options ... do
> we really need this one as well?

You say that like user-selectable options are somehow evil.  The kernel
is not Gnome.

-- 
Måns Rullgård
mans@mansr.com
