Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaHTMV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:21:29 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:33066 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaHTMV1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 20 Aug 2014 08:21:27 -0400
Message-Id: <53F4A0D202000078000BAD84@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Wed, 20 Aug 2014 13:21:22 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <gnomes@lxorguk.ukuu.org.uk>
Cc: <stefan.bader@canonical.com>, <toshi.kani@hp.com>, <x86@kernel.org>,
        <ville.syrjala@linux.intel.com>, <xen-devel@lists.xensource.com>,
        "Juergen Gross" <JGross@suse.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH RFC 0/3] x86: Full support of PAT
References: <1408454745-32358-1-git-send-email-jgross@suse.com>
 <20140820130511.771aeafa@alan.etchedpixels.co.uk>
In-Reply-To: <20140820130511.771aeafa@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> 08/20/14 2:08 PM >>>
>> The Linux kernel currently supports only 4 different cache modes. The PAT MSR
>> is set up in a way that the setting of _PAGE_PAT in a pte doesn't matter: the
>> top 4 entries in the PAT MSR are the same as the 4 lower entries.
>> 
>> This results in the kernel not supporting e.g. write-through mode. Especially
>> this cache mode would speed up drivers of video cards which now have to use
>> uncached accesses.
>
>Pentium II erratum A52 (and similar on quite a few other processors)

But you're aware that for the last two major releases Xen hasn't been supporting
32-bit CPUs at all anymore? I.e. why should we limit functionality under Xen
based on errata on 64-bit-incapable CPUs?

Jan

