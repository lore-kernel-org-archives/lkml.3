Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3HWLSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:18:47 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:12653 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab3HWLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:18:46 -0400
Message-ID: <52174512.1060803@atmel.com>
Date: Fri, 23 Aug 2013 12:18:42 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] staging: ozwpan: Create deferred work to destroy
 PD object.
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com> <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com> <20130823090509.GS22811@mwanda>
In-Reply-To: <20130823090509.GS22811@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/08/13 10:05, Dan Carpenter wrote:
> On Thu, Aug 22, 2013 at 05:38:51PM +0100, Rupesh Gujare wrote:
>> +/*------------------------------------------------------------------------------
>>    * Context: softirq-serialized
>>    */
> Don't resend the patch, but these comments are not in kernel style.
> It's explained in Documentation/kernel-doc-nano-HOWTO.txt
>
> The main thing is that could you just delete all the --------
> lines?

OK Dan, looks reasonable.

-- 
Regards,
Rupesh Gujare

