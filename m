Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab3LEOsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:48:10 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:40786 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab3LEOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:48:03 -0500
Date: Thu, 5 Dec 2013 11:47:55 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] perf trace: Fix crash on RHEL6
Message-ID: <20131205144754.GC10333@ghostprotocols.net>
References: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
 <1386211302-31303-3-git-send-email-dsahern@gmail.com>
 <20131205130924.GA10333@ghostprotocols.net>
 <52A08D68.5020701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A08D68.5020701@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 05, 2013 at 07:27:52AM -0700, David Ahern escreveu:
> On 12/5/13, 6:09 AM, Arnaldo Carvalho de Melo wrote:
> >Em Wed, Dec 04, 2013 at 07:41:40PM -0700, David Ahern escreveu:
> >>Signed-off-by: David Ahern <dsahern@gmail.com>
> >
> >What would make no fields to be present if tp_format is not NULL, i.e.
> >if the /format file was successfully parsed?
> 
> Sometimes it is not successfully parsed. I see failed to parse
> messages, so most likely the root cause. I was posting this one and
> the first one hoping you could take a look at RHEL6 problems. I
> think it is mostly an old kernel thing.

OK, just questioning because perhaps you had some insight and had just
not posted it as the changeset log msg.

- Arnaldo
