Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbaE2QFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:05:12 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47489 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932640AbaE2QFK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:05:10 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [Patch v2 4/4] tty: serial: msm: Remove direct access to GSBI
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <A56B810D-869A-4E4F-BC29-C9B0F6CDCE79@codeaurora.org>
Date: Thu, 29 May 2014 11:05:06 -0500
Cc: Andy Gross <agross@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <5A73A2BD-6113-4BC0-860F-BBE6A8232585@codeaurora.org>
References: <1398357082-5102-1-git-send-email-agross@codeaurora.org> <1398357082-5102-5-git-send-email-agross@codeaurora.org> <A56B810D-869A-4E4F-BC29-C9B0F6CDCE79@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29, 2014, at 10:14 AM, Kumar Gala <galak@codeaurora.org> wrote:

> 
> On Apr 24, 2014, at 11:31 AM, Andy Gross <agross@codeaurora.org> wrote:
> 
>> This patch removes direct access of the GSBI registers.  GSBI configuration
>> should be done through the GSBI driver directly.
>> 
>> Signed-off-by: Andy Gross <agross@codeaurora.org>
>> ---
>> drivers/tty/serial/msm_serial.c |   48 ++-------------------------------------
>> drivers/tty/serial/msm_serial.h |    5 ----
>> 2 files changed, 2 insertions(+), 51 deletions(-)
> 
> Greg,
> 
> Any update on pulling this is for next?
> 
> - k

I’ll send it via arm-soc as the related patches are going via that path.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

