Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbaHTWA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:00:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54563 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbaHTWA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:00:26 -0400
Message-ID: <53F51A3C.1040707@zytor.com>
Date: Wed, 20 Aug 2014 16:59:24 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, jgross@suse.com
CC: stefan.bader@canonical.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, ville.syrjala@linux.intel.com, x86@kernel.org
Subject: Re: [PATCH RFC 0/3] x86: Full support of PAT
References: <1408454745-32358-1-git-send-email-jgross@suse.com> <20140820130511.771aeafa@alan.etchedpixels.co.uk>
In-Reply-To: <20140820130511.771aeafa@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 07:05 AM, One Thousand Gnomes wrote:
> Doing this stuff for Xen also IMHO makes no sense at all. We shouldn't
> have a kernel full of crap to deal with Xen-isms.

We already *have* a kernel full of crap to deal with Xen-isms.  We
screwed that pooch some 10 years ago.

> IFF it means the changes can also implement a mix of four PAT entries
> on Pentium-M or earlier CPUs with PAT errata, and the full PAT on
> processors without errata then IMHO it becomes a whole world more
> interesting.

That is one of the wins, indeed, as well as handle pre-PAT processors.

	-hpa


