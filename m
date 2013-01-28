Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3A1UQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 15:16:11 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36832 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab3A1UQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:16:05 -0500
Message-ID: <1359404149.3906.75.camel@falcor1>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 15:15:49 -0500
In-Reply-To: <20130128185625.GC5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	 <1358895228.2408.14.camel@falcor1>
	 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	 <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185625.GC5868@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012820-9360-0000-0000-00000FD0F4A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 13:56 -0500, Vivek Goyal wrote:
> On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:
> 
> [..]
> > > Ok. I am hoping that it will be more than the kernel command line we
> > > support. In the sense that for digital signatures one needs to parse
> > > the signature, look at what hash algorithm has been used  and then
> > > collect the hash accordingly. It is little different then IMA requirement
> > > of calculating one pre-determine hash for all files.
> > 
> > Yes... It is obvious. It's coming.
> > But in general, signer should be aware of requirements and limitation
> > of the platform.
> > It is not really a problem...
> 
> One more question. I specified "ima_appraise_tcb" on kernel command line
> and I had an unbootable system. It refused to run "init" as it was not
> labeled/signed. Is there any policy/way where it appraises only signed
> files and does not refuse to open/execute unsigned ones.

The policy defines what needs to be measured/appraised, not the other
way around.  There's nothing preventing you from defining and loading a
different policy, one to your liking, before pivoting root.

thanks,

Mimi

