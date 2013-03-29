Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3C2KFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 06:05:14 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:9651
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737Ab3C2KFL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 06:05:11 -0400
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z1039mzbb2dI98dI9371I936eI1432I1453I1447Izz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275bhz2fh2a8h668h839h93fhd24hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
Message-ID: <1364550599.7481.8.camel@leyfoon-vm>
Subject: Re: Generic syscall ABI support
From: Ley Foon Tan <lftan@altera.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rob Landley <rob@landley.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Date: Fri, 29 Mar 2013 17:49:59 +0800
In-Reply-To: <51551E60.4070708@zytor.com>
References: <1364532097.18069.7@driftwood> <51551E60.4070708@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 21:53 -0700, H. Peter Anvin wrote:
> On 03/28/2013 09:41 PM, Rob Landley wrote:
> > 
> > You don't need a new glibc port, you need a new klibc or musl port.
> > 
> >   http://www.openwall.com/lists/musl/2012/07/08/1
> > 
> > Way less work than getting glibc working for your basic smoketest...
> > 
> 
> Good point.  Average time to port klibc to a new architecture is about
> four hours as long as the person porting knows the calling conventions
> and assembly language involved.
> 
> 	-hpa
> 
> 
Thanks for the suggestion.
Too bad we don't have in-house expert in klibc and musl port. 

Hi HPA,
I knew you are the developer of klibc. Do you have any documentation to
port a new architecture and also how to replace glibc with klibc in
build?

By the way, klibc or musl is easier to port?
Thanks.

Regards
lftan

