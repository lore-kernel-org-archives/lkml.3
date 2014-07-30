Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695AbaG3SXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:23:55 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:45142 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333AbaG3SXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:23:51 -0400
Message-ID: <53D9382F.3040206@gmail.com>
Date: Wed, 30 Jul 2014 20:23:43 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Tejun Heo <tj@kernel.org>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: kishon@ti.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 0/8] ARM: berlin: add AHCI support
References: <1406739902-26311-1-git-send-email-antoine.tenart@free-electrons.com> <20140730170923.GE23734@htj.dyndns.org>
In-Reply-To: <20140730170923.GE23734@htj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 07:09 PM, Tejun Heo wrote:
> Applied 3-5 to libata/for-3.17.  I suppose 6-8 are gonna routed
> through a different tree?

Tejun,

IMHO you should also take 6
("Documentation: bindings: document the sub-nodes AHCI bindings").

Sebastian
