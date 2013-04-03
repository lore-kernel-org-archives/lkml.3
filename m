Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3DCN4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:56:48 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34421 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab3DCN4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <515C4DE202000078000CA5F3@nat28.tlf.novell.com>
References: <512EC22F.5020404@asianux.com> <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
 <515C444002000078000CA5B5@nat28.tlf.novell.com> <CAJ75kXaHoydy4=ZTMHN8S=nyw7rRGdb4w2_Xf0oCLBQnJD6W-w@mail.gmail.com>
 <515C4DE202000078000CA5F3@nat28.tlf.novell.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 3 Apr 2013 15:56:25 +0200
Message-ID: <CAJ75kXaZrA8bN+faNEJwFp_FDxtfSBk3nPvGZW_wYajFg6y1KQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used without initialized
To: Jan Beulich <JBeulich@suse.com>
Cc: Chen Gang <gang.chen@asianux.com>, "roger.pau" <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        dgdegra <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 3:42 PM, Jan Beulich <JBeulich@suse.com> wrote:
> ChangeLog-3.8.3 for example has

oh sorry, you are right. I wasn't looking is the 3.8.x branch.
The thing is, the revert seems present only in 3.8.x branch. For
example in 3.4.x the last patch is still 01c681d
Should we consider this normal or is it a mistake?

--
William
