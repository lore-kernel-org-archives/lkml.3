Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaKDTcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 14:32:53 -0500
Received: from tex.lwn.net ([70.33.254.29]:42441 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbaKDTcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 14:32:51 -0500
Date: Tue, 4 Nov 2014 14:32:49 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipv4: add kernel parameter
 tcpmhash_entries
Message-ID: <20141104143249.608c9fe4@lwn.net>
In-Reply-To: <1415128988-11665-1-git-send-email-fabf@skynet.be>
References: <1415128988-11665-1-git-send-email-fabf@skynet.be>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Nov 2014 20:23:08 +0100
Fabian Frederick <fabf@skynet.be> wrote:

> +			Set tcp_metrics_hash slot number.

So I'm not entirely clear on what that means.  Did you mean "Set the
number of tcp_metrics_hash slots"?  If so, that wording should be used.

Even in that case, though, what does this parameter actually *mean*?  If
we're going to document the parameter (and I think we should), it would
be good to say why a user might want to change it and what effects they
would expect to see.

Care to redo with that in mind?

Thanks,

jon
