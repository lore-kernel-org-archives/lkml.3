Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255Ab3DCQiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:38:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33524 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761722Ab3DCQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:38:07 -0400
Date: Wed, 3 Apr 2013 12:37:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: William Dauchy <wdauchy@gmail.com>, Chen Gang <gang.chen@asianux.com>,
        "roger.pau" <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel <xen-devel@lists.xen.org>, dgdegra <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used without
 initialized
Message-ID: <20130403163738.GA11926@phenom.dumpdata.com>
References: <512EC22F.5020404@asianux.com>
 <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
 <515C444002000078000CA5B5@nat28.tlf.novell.com>
 <CAJ75kXaHoydy4=ZTMHN8S=nyw7rRGdb4w2_Xf0oCLBQnJD6W-w@mail.gmail.com>
 <515C4DE202000078000CA5F3@nat28.tlf.novell.com>
 <CAJ75kXaZrA8bN+faNEJwFp_FDxtfSBk3nPvGZW_wYajFg6y1KQ@mail.gmail.com>
 <515C5A0802000078000CA681@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515C5A0802000078000CA681@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 03:34:16PM +0100, Jan Beulich wrote:
> >>> On 03.04.13 at 15:56, William Dauchy <wdauchy@gmail.com> wrote:
> > On Wed, Apr 3, 2013 at 3:42 PM, Jan Beulich <JBeulich@suse.com> wrote:
> >> ChangeLog-3.8.3 for example has
> > 
> > oh sorry, you are right. I wasn't looking is the 3.8.x branch.
> > The thing is, the revert seems present only in 3.8.x branch. For
> > example in 3.4.x the last patch is still 01c681d
> > Should we consider this normal or is it a mistake?
> 
> I think it is a mistake, but ultimately it's Konrad's call.

It is a mistake. Please revert it if possible.
> 
> Jan
> 
