Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3LBM0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 07:26:32 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:34644 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3LBM02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 07:26:28 -0500
Date: Mon, 2 Dec 2013 09:26:20 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] perf Makefile: Correct the message in feature-libnuma
 checking.
Message-ID: <20131202122620.GA2371@ghostprotocols.net>
References: <529C9DFD.6040707@cn.fujitsu.com>
 <1385998008-6851-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <529BF100.2080504@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529BF100.2080504@hurleysoftware.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Dec 01, 2013 at 09:31:28PM -0500, Peter Hurley escreveu:
> On 12/02/2013 10:26 AM, Dongsheng Yang wrote:
> >The package required for numa is named numactl-devel in Fedora or RHEL,
> >and libnuma-devel in OpenSuSE, and libnuma-dev in Ubuntu. This patch
> >corrects the package name in warning message in feature-libnuma checking.
> 
> Thanks (and thanks for correcting the other lib names).

I'll take this as an:

Acked-by: Peter Hurley <peter@hurleysoftware.com>

Ok?

Please read Documentation/SubmittingPatches, relevant part:

------------------------------------------------------------
13) When to use Acked-by: and Cc:

The Signed-off-by: tag indicates that the signer was involved in the
development of the patch, or that he/she was in the patch's delivery path.

If a person was not directly involved in the preparation or handling of a
patch but wishes to signify and record their approval of it then they can
arrange to have an Acked-by: line added to the patch's changelog.

Acked-by: is often used by the maintainer of the affected code when that
maintainer neither contributed to nor forwarded the patch.

Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
has at least reviewed the patch and has indicated acceptance.  Hence patch
mergers will sometimes manually convert an acker's "yep, looks good to me"
into an Acked-by:.

Acked-by: does not necessarily indicate acknowledgement of the entire patch.
For example, if a patch affects multiple subsystems and has an Acked-by: from
one subsystem maintainer then this usually indicates acknowledgement of just
the part which affects that maintainer's code.  Judgement should be used here.
When in doubt people should refer to the original discussion in the mailing
list archives.

If a person has had the opportunity to comment on a patch, but has not
provided such comments, you may optionally add a "Cc:" tag to the patch.
This is the only tag which might be added without an explicit action by the
person it names.  This tag documents that potentially interested parties
have been included in the discussion
------------------------------------------------------------
 
Thanks,

- Arnaldo
