Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaJ0Lyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:54:49 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48933 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaJ0Lyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:54:47 -0400
Date: Mon, 27 Oct 2014 11:54:32 +0000
From: Will Deacon <will.deacon@arm.com>
To: Chai Wen <chaiw.fnst@cn.fujitsu.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yuichi.kusakabe@jp.fujitsu.com" <yuichi.kusakabe@jp.fujitsu.com>
Subject: Re: [PATCH resend] ARM: perf: remove useless return and check of idx
 in counter handling
Message-ID: <20141027115431.GO8768@arm.com>
References: <1413980209-14913-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
 <5449FF3E.6080108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5449FF3E.6080108@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 08:26:54AM +0100, Chai Wen wrote:
> Hi Will
> 
> Ping...

Sorry, I was on holiday for the latter part of last week. I've applied this
locally and I'll send it via rmk for 3.19, as I don't think it's urgent.

Thanks,

Will
