Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722Ab3DCN0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:26:16 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37943 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760794Ab3DCN0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:26:15 -0400
MIME-Version: 1.0
In-Reply-To: <515C444002000078000CA5B5@nat28.tlf.novell.com>
References: <512EC22F.5020404@asianux.com> <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
 <515C444002000078000CA5B5@nat28.tlf.novell.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 3 Apr 2013 15:25:54 +0200
Message-ID: <CAJ75kXaHoydy4=ZTMHN8S=nyw7rRGdb4w2_Xf0oCLBQnJD6W-w@mail.gmail.com>
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

Hello Jan,

On Wed, Apr 3, 2013 at 3:01 PM, Jan Beulich <JBeulich@suse.com> wrote:
> Iirc we requested the earlier commit to be removed from stable
> trees, and I think Greg also did so.

I'm sorry but I'm unable to find a revert of 01c681d in stable tree.

Regards,
--
William
