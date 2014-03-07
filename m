Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaCGRCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 12:02:51 -0500
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:59796 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbaCGRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 12:02:49 -0500
Date: Fri, 7 Mar 2014 11:02:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
In-Reply-To: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
Message-ID: <alpine.DEB.2.10.1403071100470.21846@nuc>
References: <20140306192234.62ad3ac104a2adc16752b033@canb.auug.org.au>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2014, Stephen Rothwell wrote:

>
> I have reverted that commit for today.
>
> I suspect that this whole series may need more review and work.

Toss the bits that do not build for now. These can then be handled in
individual patches since the overall framework is present.

