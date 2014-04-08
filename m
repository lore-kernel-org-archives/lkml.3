Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaDHOZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 10:25:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50964 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbaDHOZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 10:25:04 -0400
Message-ID: <534406BD.8000702@codeaurora.org>
Date: Tue, 08 Apr 2014 10:25:01 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v6 2/5] ARM: Add Krait L2 register accessor functions
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org> <1396641450-12854-3-git-send-email-sboyd@codeaurora.org> <20140407201838.GC20822@pd.tnic> <20140407215649.GH9985@codeaurora.org> <20140408064328.GB30077@pd.tnic>
In-Reply-To: <20140408064328.GB30077@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 04/08/2014 02:43 AM, Borislav Petkov wrote:
> On Mon, Apr 07, 2014 at 02:56:49PM -0700, Stephen Boyd wrote:
>> No. This is the template I'm told to use.
> 
> By whom? And why?

As I understand it, the license authors. They find it important to maintain
clarity even when files get copied into other projects.

http://www.gnu.org/licenses/gpl-howto.html

http://www.gnu.org/licenses/gpl-faq.html#NoticeInSourceFile

Regards,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
