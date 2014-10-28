Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaJ1NE4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:04:56 -0400
Received: from tex.lwn.net ([70.33.254.29]:43238 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbaJ1NEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:04:54 -0400
Date: Tue, 28 Oct 2014 09:04:51 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [patch] Documentation/SubmittingPatches: Reported-by tags and
 permission
Message-ID: <20141028090451.41ed6aad@lwn.net>
In-Reply-To: <20140214093001.GA15933@elgon.mountain>
References: <1392333751.29034.3.camel@x220>
	<20140214093001.GA15933@elgon.mountain>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb 2014 12:30:01 +0300
Dan Carpenter <dan.carpenter@oracle.com> wrote:

> -If this patch fixes a problem reported by somebody else, consider adding a
> -Reported-by: tag to credit the reporter for their contribution.  Please
> -note that this tag should not be added without the reporter's permission,
> -especially if the problem was not reported in a public forum.  That said,
> -if we diligently credit our bug reporters, they will, hopefully, be
> -inspired to help us again in the future.
> +The Reported-by tag is to give credit to people who find bugs and report them.
> +Please note that if the bug was reported in private, then ask for permission
> +first before using the Reported-by tag.

As the guy who wrote the original text, I think this is an
improvement...but can we get a version that retains the motivation for
crediting bug reporters in the first place?

Thanks,

jon
