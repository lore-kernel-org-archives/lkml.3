Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaE0SEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:04:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57943 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaE0SEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:04:53 -0400
Date: Tue, 27 May 2014 11:05:04 -0700
From: Olof Johansson <olof@lixom.net>
To: Kumar Gala <galak@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] ARM: config: Update msm_defconfig
Message-ID: <20140527180504.GC26141@quad.lixom.net>
References: <1393467394-10907-1-git-send-email-sboyd@codeaurora.org>
 <1393467394-10907-4-git-send-email-sboyd@codeaurora.org>
 <20140227221458.GA5334@codeaurora.org>
 <318973D9-95B5-4D53-B774-D4239FD9AECB@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <318973D9-95B5-4D53-B774-D4239FD9AECB@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 06:22:37PM -0600, Kumar Gala wrote:
> 
> On Feb 27, 2014, at 4:14 PM, David Brown <davidb@codeaurora.org> wrote:
> 
> > On Wed, Feb 26, 2014 at 06:16:34PM -0800, Stephen Boyd wrote:
> >> Now that DT based platforms are split out of mach-msm into
> >> mach-qcom, put back a non-DT based SoC into the msm_defconfig and
> >> stop selecting unsupported drivers.
> >> 
> >> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> >> ---
> >> arch/arm/configs/msm_defconfig | 25 +++----------------------
> >> 1 file changed, 3 insertions(+), 22 deletions(-)
> > 
> > Acked-by: David Brown <davidb@codeaurora.org>
> > 
> > Kumar, can you just pull this in with the other qcom changes from
> > Sephen?
> 
> sure

I didn't see 2/3 land in our tree through branches from you. Should I
just apply it directly by now?


-Olof
