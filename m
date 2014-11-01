Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbaKATq4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 15:46:56 -0400
Received: from mout.gmx.net ([212.227.17.20]:54467 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758825AbaKATqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 15:46:53 -0400
Message-ID: <545538A2.7080403@gmx.de>
Date: Sat, 01 Nov 2014 20:46:42 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:32.0) Gecko/20100101 Firefox/32.0 SeaMonkey/2.29
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4] iio: iadc: Qualcomm SPMI PMIC current ADC driver
References: <1413987213-22218-1-git-send-email-iivanov@mm-sol.com>	 <5453ED55.2000003@gmx.de> <1414859945.2207.1.camel@mm-sol.com>
In-Reply-To: <1414859945.2207.1.camel@mm-sol.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:UCw62cnzxQcXC200T+YDDncob0hUyFkBORVFbkwZczcsoFArDg8
 nJ92Bg9RWtK/aDp3nHhzCP60Cf9Vm5FCN42zSsDuhJ7ac8JaucEMrG7qfIFNVf+nOPXsecW
 JQ0hJti22d+8bYuQKFxnTazXu2aBTJ2NPPu5bau48vEb+g+4iZB5Ti8miP6rGinPav7mHcQ
 bkm1lz2r5orO6BGBDD69A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan T. Ivanov schrieb am 01.11.2014 17:39:
> 
> On Fri, 2014-10-31 at 21:13 +0100, Hartmut Knaack wrote:
>> Ivan T. Ivanov schrieb am 22.10.2014 16:13:
>>> The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>>> 16 bits resolution and register space inside PMIC accessible across
>>> SPMI bus.
>>>
>>> The driver registers itself through IIO interface.
>> Pretty much there, just one question I would like to double-check: 
>> The CPU of these chips is Little Endian, right?
> 
> Yes, it is Little Endian.
Cool.
> 
>> Annoyingly, you introduced a small typo in this revision, 
> 
> No it is not a typo. Calculation is really in nano Ohms.
Right, but the typo is, that you wrote "nono" instead of "nano".
> 
> Regards,
> Ivan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

