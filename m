Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3FKDPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 23:15:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:49182 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3FKDPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 23:15:53 -0400
Message-ID: <51B69663.5080304@linaro.org>
Date: Tue, 11 Jun 2013 08:45:47 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>
CC: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 09/15] net: can: Convert to use devm_ioremap_resource
References: <1370864113-17895-1-git-send-email-tushar.behera@linaro.org> <1370864113-17895-10-git-send-email-tushar.behera@linaro.org> <51B5D007.8050005@pengutronix.de>
In-Reply-To: <51B5D007.8050005@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+CC: 'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>

On 06/10/2013 06:39 PM, Marc Kleine-Budde wrote:
> On 06/10/2013 01:35 PM, Tushar Behera wrote:
>> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
>> introduced devm_ioremap_resource() and deprecated the use of
>> devm_request_and_ioremap().
> 
> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> Are the patches going over the individual subsystem maintainers?
> 
> Marc
> 

I am not sure. Looping in Greg for clarity.

-- 
Tushar Behera
