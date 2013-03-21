Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932900Ab3CUMmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:42:21 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:55722 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3CUMmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <1363869542.17680.26.camel@pasglop>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca> <1363869542.17680.26.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 21 Mar 2013 12:41:59 +0000
X-Google-Sender-Auth: s98HFGR1RhGnnhdj1C74owAXgik
Message-ID: <CACxGe6sig_PNwcKqjY9aOD3QW_C1nEoZ31nDKKXXV0wUnzo36A@mail.gmail.com>
Subject: Re: Kobjectify device tree structures
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 12:39 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2013-03-21 at 11:24 +0000, Grant Likely wrote:
>>  11 files changed, 147 insertions(+), 342 deletions(-)
>
> Nice :-)

:-) Thanks! ...and about 20% of the additions are ABI documentation.

g.
