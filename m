Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309Ab3DBUjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:39:15 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54949 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762281Ab3DBUjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:39:14 -0400
Message-ID: <515B41EA.8040704@ti.com>
Date: Tue, 2 Apr 2013 13:39:06 -0700
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jonghwan Choi <jhbird.choi@samsung.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3.8-stable] regulator: core: Log when a device causes
 a voltage
References: <009001ce2f84$beb22ea0$3c168be0$%choi@samsung.com> <20130402200257.GB8177@kroah.com>
In-Reply-To: <20130402200257.GB8177@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 01:02 PM, Greg KH wrote:
> On Tue, Apr 02, 2013 at 06:30:42PM +0900, Jonghwan Choi wrote:
>> 3.8-stable review patch.  If anyone has any objections, please let us know.
>>
>> ------------------
>>
>> From: "Russ Dill <Russ.Dill@ti.com>"
>>
>> commit 6e45eb12fd1c741d556bf264ee98853b5f3104e5 upstream.
> 
> Wait, no, this is NOT the commit id of this patch, please don't get this
> wrong.
> 
> I've dropped this from my stable mbox, if Russ feels this should go to
> 3.8-stable, please send me the correct git id of the patch to apply.

9c7b4e8a8ad2624106fbf690fa97ab9c8c9bfa88 is the proper upstream commit.
This fixes a potential oops that was added in 3.8-rc4, and fixed
upstream in 3.9-rc1. I do think it belongs in stable.

Too bad I can't muck up the commit, then I'd owe you a beer. Might help
that shoulder of yours.

