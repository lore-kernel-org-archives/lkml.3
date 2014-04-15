Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaDOJd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:33:26 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:61964 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752745AbaDOJdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:33:19 -0400
Message-ID: <1397554396.1985.31.camel@x220>
Subject: Re: [PATCH 04/28] Remove EXYNOS_DEV_SYSMMU
From: Paul Bolle <pebolle@tiscali.nl>
To: Sachin Kamat <sachin.kamat@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Date: Tue, 15 Apr 2014 11:33:16 +0200
In-Reply-To: <CAK9yfHzP0ekboc-yi6FHvR3_rRiqcLC18pE2UynpxGYO0mUOsw@mail.gmail.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-5-git-send-email-richard@nod.at>
	 <1391976496.25855.19.camel@x220>
	 <CAK9yfHzP0ekboc-yi6FHvR3_rRiqcLC18pE2UynpxGYO0mUOsw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 09:33:16.0764 (UTC) FILETIME=[BAFA69C0:01CF588D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 10:02 +0530, Sachin Kamat wrote:
> +cc linux-samsung-soc list
> 
> On 10 February 2014 01:38, Paul Bolle <pebolle@tiscali.nl> wrote:
> > I noted this one about a year ago (see
> > https://lkml.org/lkml/2013/3/5/401 ). By now I wonder whether
> > EXYNOS_IOMMU (and everything depending on it) shouldn't be removed. That
> > code has been unbuildable for at least a year now  (I have not checked
> > how much code is involved).
> 
> 
> Please refer to some on-going discussion about it at [1].
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/26842

It's not clear to me whether an actual decision was eventually made.
Olof, does it make sense to rebase the patch (that Sachin linked to) on
onto v3.15-rc1 and resubmit?


Paul Bolle

