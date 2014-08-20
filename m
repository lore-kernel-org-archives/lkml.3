Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHTWBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:01:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaHTWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:01:05 -0400
Message-ID: <53F51A80.4060902@zytor.com>
Date: Wed, 20 Aug 2014 17:00:32 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jan Beulich <jbeulich@suse.com>, gnomes@lxorguk.ukuu.org.uk
CC: stefan.bader@canonical.com, toshi.kani@hp.com, x86@kernel.org,
        ville.syrjala@linux.intel.com, xen-devel@lists.xensource.com,
        Juergen Gross <JGross@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH RFC 0/3] x86: Full support of PAT
References: <1408454745-32358-1-git-send-email-jgross@suse.com> <20140820130511.771aeafa@alan.etchedpixels.co.uk> <53F4A0D202000078000BAD84@mail.emea.novell.com>
In-Reply-To: <53F4A0D202000078000BAD84@mail.emea.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2014 07:21 AM, Jan Beulich wrote:
> 
> But you're aware that for the last two major releases Xen hasn't been supporting
> 32-bit CPUs at all anymore? I.e. why should we limit functionality under Xen
> based on errata on 64-bit-incapable CPUs?
> 

Because there is no fscking way we're doing this differently on 32 and
64 bits.  Quite frankly the issue is if we should support this under Xen
at all, but I think we can do it cleanly.

	-hpa


