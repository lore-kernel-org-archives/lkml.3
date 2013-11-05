Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3KELqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:46:46 -0500
Received: from collab.rosalab.ru ([195.19.76.181]:46360 "EHLO
	collab.rosalab.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3KELqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:46:45 -0500
Message-ID: <5278DA7C.6010708@rosalab.ru>
Date: Tue, 05 Nov 2013 15:46:04 +0400
From: Eugene Shatokhin <eugene.shatokhin@rosalab.ru>
Organization: ROSA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Usyskin, Alexander" <alexander.usyskin@intel.com>
CC: =?UTF-8?B?Tmljb2zDsiBDb3N0YW56YQ==?= <abitrules@yahoo.it>,
        Alex Burmashev <alex.burmashev@rosalab.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: mei: cancel stall timers in mei_reset
References: <1361817048.3583.1383580128332.JavaMail.root@collab.rosalab.ru> <5278A741.6040206@rosalab.ru> <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com>
In-Reply-To: <C980C034A53E0646B96866D6CE3D187A3330D460@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/05/2013 01:58 PM, Usyskin, Alexander wrote:
> The problem that you found was fixed in patch here: https://lkml.org/lkml/2013/6/23/169
> And this patch merged into 3.11 according to http://lxr.free-electrons.com/source/drivers/misc/mei/mei_dev.h?v=3.11
> Can you re-check with latest 3.11 point release?

Thanks for the info!

Yes, I found this patch an hour ago as well as a similar one for hw_reset.

As we are currently more interested in kernel 3.10.x in ROSA (it is our 
main production kernel), I will apply these patches to it first and 
re-check.

Regards,

Eugene

-- 
Eugene Shatokhin, ROSA Laboratory.
www.rosalab.com
