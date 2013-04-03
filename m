Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762784Ab3DCM5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:57:02 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:60565 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760614Ab3DCM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <512EC22F.5020404@asianux.com>
References: <512EC22F.5020404@asianux.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Wed, 3 Apr 2013 14:56:39 +0200
Message-ID: <CAJ75kXZc+GtYi7ULs96G3VkmyzkS5-qe702iXpNenpPj8GF5BQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/block/xen-blkback: preq.dev is used without initialized
To: Chen Gang <gang.chen@asianux.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jan Beulich <JBeulich@suse.com>, roger.pau@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        dgdegra@tycho.nsa.gov, xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 28, 2013 at 3:34 AM, Chen Gang <gang.chen@asianux.com> wrote:
> additional information:
>   before commit 01c681d4c70d64cb72142a2823f27c4146a02e63, the value printed
>   here was bogus, as it was the guest provided value from req->u.rw.handle
>   rather than the actual device.
>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Jan Beulich <JBeulich@suse.com>

Sorry I'm a bit late but since since 01c681d is in stable, I guess
a72d900 (xen/xen-blkback: preq.dev is used without initialized)
could be added in stable as well.
Am I wrong? otherwise I'm ok to do the request.

Regards,

--
William
