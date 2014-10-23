Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaJWGJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 02:09:17 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65421 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJWGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 02:09:15 -0400
Date: Thu, 23 Oct 2014 10:09:12 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, shuahkh@osg.samsung.com,
        linux-api@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 3/3] selftests/kcmp: Always try to build the test
Message-ID: <20141023060912.GD16267@moon>
References: <1414040834-30209-1-git-send-email-mpe@ellerman.id.au>
 <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414040834-30209-3-git-send-email-mpe@ellerman.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 04:07:14PM +1100, Michael Ellerman wrote:
> Don't prevent the test building on non-x86. Just try and build it and
> let the chips fall where they may.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

kcmp depends on checkpoint/restore config symbol which is known
to work on x86 and (iirc) on arm, that's why x86 was only allowed.
I don't mind to such change but not sure.
