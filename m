Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3I3NTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:19:48 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:43623 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3I3NTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:19:46 -0400
Message-ID: <52497A6E.5010908@gmail.com>
Date: Mon, 30 Sep 2013 08:19:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 01/21] drivers: remove unnecessary prom.h includes
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com> <1380221456-11192-2-git-send-email-robherring2@gmail.com> <52492E4F.2020701@pengutronix.de>
In-Reply-To: <52492E4F.2020701@pengutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2013 02:54 AM, Marc Kleine-Budde wrote:
> On 09/26/2013 08:50 PM, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Remove unnecessary prom.h includes in preparation to remove implicit
>> includes of prom.h.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>> Cc: linux-can@vger.kernel.org
>> Cc: netdev@vger.kernel.org
> 
> Applied to linux-can-next/testing, it will be included in my next pull
> request to David Miller.

Please don't apply this. The whole series needs to be applied together.
This patch is a dependency for the rest of the series.

Rob

