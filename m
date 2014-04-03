Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbaDCQdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:33:11 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56839 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaDCQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:33:02 -0400
Message-ID: <533D8D3C.4010108@mm-sol.com>
Date: Thu, 03 Apr 2014 19:33:00 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 2/9] crypto: qce: Add register defines
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com> <1396541886-10966-3-git-send-email-svarbanov@mm-sol.com> <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
In-Reply-To: <69C277DD-FAB2-4102-BA97-8C1985E099CB@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/03/2014 07:24 PM, Kumar Gala wrote:
> 
> On Apr 3, 2014, at 11:17 AM, Stanimir Varbanov <svarbanov@mm-sol.com> wrote:
> 
>> Here are all register addresses and bit/masks used by the driver.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>> ---
>> drivers/crypto/qce/regs-v5.h | 327 +++++++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 327 insertions(+)
>> create mode 100644 drivers/crypto/qce/regs-v5.h
> 
> This should be part of the first patch in the series, you shouldn’t have any patch that doesn’t build.

Correct, I thought I mentioned in the cover letter that the series is
splitted by files to easier the review. I planned to squash all in one
patch after review is done.

regards,
Stan

