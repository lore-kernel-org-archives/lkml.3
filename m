Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3HES6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:58:23 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:37962 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3HES6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:58:22 -0400
Message-ID: <51FFF5CB.7020100@atmel.com>
Date: Mon, 5 Aug 2013 19:58:19 +0100
From: Rupesh Gujare <rupesh.gujare@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <devel@linuxdriverproject.org>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] staging: ozwpan: Reset port configuration number.
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com> <1375724415-10801-4-git-send-email-rupesh.gujare@atmel.com> <20130805182128.GL5051@mwanda>
In-Reply-To: <20130805182128.GL5051@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/13 19:21, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 06:40:14PM +0100, Rupesh Gujare wrote:
>> Make sure that we reset port configuration no. when PD departs.
>>
> What happens if we don't do this?  What is the user visible effect
> of this patch?
>
>

There is no user visible effect at the moment. Clearing this variable as 
safeguard measure.

-- 
Regards,
Rupesh Gujare

