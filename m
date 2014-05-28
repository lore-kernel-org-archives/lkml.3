Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbaE1UsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:48:09 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:52211 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751696AbaE1UsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:48:06 -0400
Message-ID: <1401310082.6186.16.camel@x220>
Subject: Re: linux-next: build failure after merge of the final tree
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 22:48:02 +0200
In-Reply-To: <20140528204232.GA8224@kroah.com>
References: <20140528194629.0757af1b@canb.auug.org.au>
	 <1401271041.28714.22.camel@x220> <1401272095.28714.30.camel@x220>
	 <1401308488.6186.10.camel@x220> <20140528204232.GA8224@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2014 20:48:03.0271 (UTC) FILETIME=[1E945D70:01CF7AB6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 13:42 -0700, Greg KH wrote:
> Either is fine with me, I can revert it, or apply a fix, which ever you
> want, just let me know.

Well, a proper fix would make this whole episode worthwhile. But if I
can't come up with anything that actually builds in a day or two it'll
have to be a revert. If that exceeds your patience you're free to hand
me a shorter deadline.


Paul Bolle

