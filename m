Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaJ0Mre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:47:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47242 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbaJ0Mrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:47:32 -0400
Date: Mon, 27 Oct 2014 12:47:29 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 06/11] wm8350-core: Fix probable mask then right shift
	defect
Message-ID: <20141027124729.GF23178@opensource.wolfsonmicro.com>
References: <cover.1414387334.git.joe@perches.com> <9151d02031748dbc1637c1cc9110214617d9bcf1.1414387334.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9151d02031748dbc1637c1cc9110214617d9bcf1.1414387334.git.joe@perches.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 10:25:02PM -0700, Joe Perches wrote:
> Precedence of & and >> is not the same and is not left to right.
> shift has higher precedence and should be done after the mask.
> 
> Add parentheses around the mask.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
