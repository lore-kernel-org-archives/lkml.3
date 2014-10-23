Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaJWGEM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:04:12 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39362 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJWGEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:04:10 -0400
Date: Thu, 23 Oct 2014 10:04:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/3] kcmp: Move kcmp.h into uapi
Message-ID: <20141023060407.GB16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:12PM +1100, Michael Ellerman wrote:
> kcmp.h appears to be part of the API, it's documented in kcmp(2), and
> the selftests/kcmp code uses it. So move it to uapi so it's actually
> exported.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
