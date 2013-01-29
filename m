Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab3A2Qgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:36:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50267 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab3A2Qgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:36:40 -0500
Date: Tue, 29 Jan 2013 11:30:36 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
Message-ID: <20130129163036.GB21930@redhat.com>
References: <1358895228.2408.14.camel@falcor1>
 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
 <20130125210157.GA13152@redhat.com>
 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
 <20130128151527.GA5868@redhat.com>
 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
 <20130128185242.GB5868@redhat.com>
 <1359402694.3906.53.camel@falcor1>
 <20130128201316.GA14405@redhat.com>
 <1359418442.3906.188.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359418442.3906.188.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 07:14:02PM -0500, Mimi Zohar wrote:

[..]
> The 'trusted' keyring is a solution for installing only distro or third
> party signed packages.  How would a developer, for instance, create,
> sign, and install his own package and add his public key safely?

Hi Mimi,

I guess using MOK, developer should be able to import his public key in
shim database and in turn in kernel and use that to load user signed
moduels.

Thanks
Vivek
