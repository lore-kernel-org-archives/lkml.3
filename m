Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933719AbaD2OYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:24:21 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60862 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933428AbaD2OYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:24:19 -0400
Message-ID: <535FB610.8070006@mm-sol.com>
Date: Tue, 29 Apr 2014 17:24:16 +0300
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, linux-arm-msm@vger.kernel.org,
        Mona Hossain <mhossain@codeaurora.org>,
        Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
        Zhen Kong <zkong@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [RFC PATCH v2 4/9] crypto: qce: Add ablkcipher algorithms
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com> <1397479725-20954-5-git-send-email-svarbanov@mm-sol.com> <20140428080006.GA14510@gondor.apana.org.au>
In-Reply-To: <20140428080006.GA14510@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review!

On 04/28/2014 11:00 AM, Herbert Xu wrote:
> On Mon, Apr 14, 2014 at 03:48:40PM +0300, Stanimir Varbanov wrote:
>>
>> +	if (IS_AES(flags)) {
>> +		switch (keylen) {
>> +		case AES_KEYSIZE_128:
>> +		case AES_KEYSIZE_256:
>> +			break;
>> +		default:
>> +			goto badkey;
> 
> You need to support 192 here.  If the hardware doesn't do that
> you can work around it by using a software fallback.

Sure, I will make a software fallback. Thanks.

> 
> In general you need to provide everything that is supported by
> the generic software implementation.


-- 
regards,
Stan
