Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab3BUBc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 20:32:57 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:64781 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3BUBc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 20:32:56 -0500
Message-ID: <51257943.3070509@mentor.com>
Date: Thu, 21 Feb 2013 05:32:51 +0400
From: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Organization: Mentor Graphics Corporation
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: <devicetree-discuss@lists.ozlabs.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of/i2c: don't register disabled devices
References: <1361384904-13853-1-git-send-email-dmitry_eremin@mentor.com> <51251F51.2010003@gmail.com>
In-Reply-To: <51251F51.2010003@gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Feb 2013 01:32:54.0474 (UTC) FILETIME=[5EE27AA0:01CE0FD3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/13 23:09, Rob Herring wrote:
> On 02/20/2013 12:28 PM, Dmitry Eremin-Solenikov wrote:
>> Don't register i2c slave device tree nodes which have
>> status = "disabled" property.
>>
> 
> This is already in 3.8.

Ah, true. Sorry for the noise then.

-- 
With best wishes
Dmitry
