Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbaFRJKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:10:15 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:62609 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964840AbaFRJKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:10:12 -0400
Message-ID: <1403082609.1984.66.camel@x220>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Richard Weinberger <richard@nod.at>,
        Chen Liqin <liqin.linux@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Wed, 18 Jun 2014 11:10:09 +0200
In-Reply-To: <1397673008.6361.0.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-17-git-send-email-richard@nod.at>
	 <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
	 <1397553547.1985.25.camel@x220>
	 <CAF0htA403PKyAgQjrMpYgawNZWKZm06UYrgV-7N_9tbas=SniA@mail.gmail.com>
	 <1397673008.6361.0.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 09:10:10.0097 (UTC) FILETIME=[1AE5D210:01CF8AD5]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennox,

On Wed, 2014-04-16 at 20:30 +0200, Paul Bolle wrote:
> On Thu, 2014-04-17 at 01:29 +0800, Lennox Wu wrote:
> > OK, we will merge it into our tree.

The last few messages in this thread were sent shortly after v3.15-rc1.
We're now at v3.16-rc1 and those three references to GENERIC_HAS_IOMAP
are still there.

Are there any issues with this patch?


Paul Bolle

