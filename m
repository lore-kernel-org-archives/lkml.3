Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab3IWMvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 08:51:24 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34464 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab3IWMvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 08:51:22 -0400
Message-ID: <52403944.7080401@cogentembedded.com>
Date: Mon, 23 Sep 2013 16:51:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Ondrej Zary <linux@rainbow-software.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org> <20130922214250.GA27616@mtj.dyndns.org>
In-Reply-To: <20130922214250.GA27616@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-09-2013 1:42, Tejun Heo wrote:

>> The test for 2nd I/O port validity is broken (reversed):
>> On devices with no control port, the driver attempts to use invalid port 0,
>> resulting in logs full of bad_io_access errors.
>> On devices with control port, the driver does not use it.

>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

> Applied to libata/for-3.13.

    Why only 3.13? Isn't it a simple fix?

> Thanks.

WBR, Sergei

