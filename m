Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaILNVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 09:21:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37041 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaILNVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 09:21:41 -0400
Message-ID: <5412F360.3020600@collabora.co.uk>
Date: Fri, 12 Sep 2014 15:21:36 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: kgene@kernel.org
CC: "'Doug Anderson'" <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Mark Brown'" <broonie@kernel.org>,
        "'Naveen Krishna Chatradhi'" <ch.naveen@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Andreas Faerber'" <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>
Subject: Re: [PATCH v3 0/7] Add max77802 support for Peach boards
References: <1410344391-5675-1-git-send-email-javier.martinez@collabora.co.uk> <0ae801cfce84$be443620$3acca260$@kernel.org>
In-Reply-To: <0ae801cfce84$be443620$3acca260$@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On 09/12/2014 02:26 PM, kgene@kernel.org wrote:
>> This is a third version of th series that adds max77802 support for
>> the Peach Pit and Pi boards. The series also have all the pending
>> patches that were posted but depended on this support. I've picked
>> all the patches I found and rebased them to be sure that they apply
>> cleanly on top of linux-next. Also I've taken some DT snippets from
>> the downstream Chrome OS 3.8 kernel DTS for devices that use one of
>> these regulators as their input supply.
>> 
> Thanks a lot and looks good to me. I'll take this whole series.
> 

Great, thanks a lot!

> - Kukjin
> 

Best regards,
Javier
