Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJWGF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:05:28 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63394 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaJWGF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:05:27 -0400
Date: Thu, 23 Oct 2014 10:05:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 2/3] selftests/kcmp: Don't include kernel headers
Message-ID: <20141023060524.GC16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
 <1414040834-30209-2-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414040834-30209-2-git-send-email-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:13PM +1100, Michael Ellerman wrote:
> The kcmp test mucks with the include path to bring in the kernel
> headers, and x86 headers too for reasons that are not clear.
> 
> Now that kcmp.h is exported none of that should be necessary.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

The reason was to be able to run test without userspace headers generated.
Still this one is better I think.

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
