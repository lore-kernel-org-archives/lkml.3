Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3DCOdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:33:38 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49112 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758341Ab3DCOdf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 3 Apr 2013 10:33:35 -0400
Message-Id: <515C5A0802000078000CA681@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 03 Apr 2013 15:34:16 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "William Dauchy" <wdauchy@gmail.com>
Cc: "Chen Gang" <gang.chen@asianux.com>, "roger.pau" <roger.pau@citrix.com>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "dgdegra" <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used
 without initialized
References: <512EC22F.5020404@asianux.com>
 <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
 <515C444002000078000CA5B5@nat28.tlf.novell.com>
 <CAJ75kXaHoydy4=ZTMHN8S=nyw7rRGdb4w2_Xf0oCLBQnJD6W-w@mail.gmail.com>
 <515C4DE202000078000CA5F3@nat28.tlf.novell.com>
 <CAJ75kXaZrA8bN+faNEJwFp_FDxtfSBk3nPvGZW_wYajFg6y1KQ@mail.gmail.com>
In-Reply-To: <CAJ75kXaZrA8bN+faNEJwFp_FDxtfSBk3nPvGZW_wYajFg6y1KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.04.13 at 15:56, William Dauchy <wdauchy@gmail.com> wrote:
> On Wed, Apr 3, 2013 at 3:42 PM, Jan Beulich <JBeulich@suse.com> wrote:
>> ChangeLog-3.8.3 for example has
> 
> oh sorry, you are right. I wasn't looking is the 3.8.x branch.
> The thing is, the revert seems present only in 3.8.x branch. For
> example in 3.4.x the last patch is still 01c681d
> Should we consider this normal or is it a mistake?

I think it is a mistake, but ultimately it's Konrad's call.

Jan

