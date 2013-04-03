Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761774Ab3DCNlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:41:45 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57768 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966Ab3DCNln convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Wed, 3 Apr 2013 09:41:43 -0400
Message-Id: <515C4DE202000078000CA5F3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 03 Apr 2013 14:42:26 +0100
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
In-Reply-To: <CAJ75kXaHoydy4=ZTMHN8S=nyw7rRGdb4w2_Xf0oCLBQnJD6W-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 03.04.13 at 15:25, William Dauchy <wdauchy@gmail.com> wrote:
> On Wed, Apr 3, 2013 at 3:01 PM, Jan Beulich <JBeulich@suse.com> wrote:
>> Iirc we requested the earlier commit to be removed from stable
>> trees, and I think Greg also did so.
> 
> I'm sorry but I'm unable to find a revert of 01c681d in stable tree.

ChangeLog-3.8.3 for example has

commit 32f4d10ed8fd7ef4cebbf02c5326e8bb6aeca9b1
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue Mar 12 15:08:26 2013 -0700

    Revert "xen/blkback: Don't trust the handle from the frontend."
    
    This reverts commit 01c681d4c70d64cb72142a2823f27c4146a02e63 upstream
    (ef56ca64ea733c3b88f0bb74b04da128b1dc35d8 in this tree), as it wasn't
    supposed to have been applied to the stable tree.
    
    Cc: Jan Beulich <jbeulich@suse.com>
    Cc: Ian Campbell <ian.campbell@citrix.com>
    Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Jan

